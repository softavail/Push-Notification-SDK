package com.syniverse.scg.push.demo;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Handler;
import android.preference.PreferenceManager;
import androidx.core.app.NotificationCompat;
import android.util.Log;

import com.syniverse.scg.push.sdk.ScgCallback;
import com.syniverse.scg.push.sdk.ScgClient;
import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgPushReceiver;
import com.syniverse.scg.push.sdk.ScgState;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import me.leolin.shortcutbadger.ShortcutBadger;

/**
 * Created by lekov on 7/7/16.
 */
public class MainReceiver extends ScgPushReceiver {

    public static final String MESSAGE_ID = "com.syniverse.scg.push.demo.extra.ID";
    public static final String MESSAGE = "com.syniverse.scg.push.demo.extra.MESSAGE";
    private static final String TAG = "MainReceiver";
    SharedPreferences mPrefs;

    @Override
    protected void onPushTokenReceived(String token) {
        if (!ScgClient.isInitialized()) {
            Log.w(TAG, "onPushTokenReceived() called with: token = [" + token + "], " +
                        "but ScgClient was not initialized, so message was not handled.");
            return;
        }

        ScgClient.getInstance().registerPushToken(token, new ScgCallback() {
            @Override
            public void onSuccess(int code, String message) {

            }

            @Override
            public void onFailed(int code, String message) {

            }
        });
    }

    @Override
    protected void onMessageReceived(final String messageId, final ScgMessage message) {
        checkBadgeCount(message);

        if (!ScgClient.isInitialized()) {
            Log.w(TAG, "onMessageReceived() called with: messageId = [" + messageId + "], message = [" + message + "] " +
                    "but ScgClient was not initialized, so message was not handled.");
            return;
        }
        deliveryReport(messageId);
        if (message.isInbox()) {
            return;
        }

        final String msg = message.getBody();

        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra(MESSAGE_ID, messageId);
        intent.putExtra(MESSAGE, message);
        intent.setAction(Long.toString(System.currentTimeMillis()));
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        final Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        final NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        final NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("SCG Message")
                .setContentText(msg)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setTicker(String.format("%s: %s", "SCG Message", msg))
                .setContentIntent(pendingIntent);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (message.hasDeepLink()) {
                    ScgClient.getInstance().resolveTrackedLink(message.getDeepLink(), new ScgCallback() {
                        @Override
                        public void onSuccess(int i, String s) {
                            notificationBuilder.addAction(0, "Link", PendingIntent.getActivity(context, 0, new Intent(Intent.ACTION_VIEW, Uri.parse(s)), PendingIntent.FLAG_UPDATE_CURRENT));
                            notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                        }

                        @Override
                        public void onFailed(int i, String s) {
                        }
                    });
                }
            }
        }, 1000);

        notificationManager.notify(messageId.hashCode(), notificationBuilder.build());

        if (message.hasAttachment() && message.getAttachment() != null) {
            new ScgClient.DownloadAttachment(context) {
                @Override
                protected void onPreExecute() {
                    notificationBuilder.setProgress(100, 0, true);
                    notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                }

                @Override
                protected void onResult(String mimeType, Uri result) {
                    Intent attachmentIntent = new Intent(Intent.ACTION_VIEW);
                    attachmentIntent.setDataAndType(result, mimeType);
                    notificationBuilder.setProgress(0, 0, false);

                    if (mimeType.startsWith("image")) {
                        notificationBuilder.setStyle(new NotificationCompat.BigPictureStyle().bigPicture(getThumbnail(result)));
                    }

//                    notificationBuilder.addAction(0, "Attachment", PendingIntent.getActivity(context, 0, attachmentIntent, PendingIntent.FLAG_UPDATE_CURRENT));
                    notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                }

                @Override
                protected void onFailed(int code, String error) {
                    Log.e(TAG, "onPostExecute: Cannot download attachment");
                    notificationBuilder.setProgress(0, 0, false);
                    notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                }
            }.execute(messageId, message.getAttachment());
        }

        abortBroadcast();
    }

    private void checkBadgeCount(ScgMessage message) {
        if (message != null) {
            int badge = message.getBadge();
            if (badge > -1) {
                if (badge == 0) {
                    ShortcutBadger.removeCount(context);
                } else {
                    ShortcutBadger.applyCount(context, badge);
                }

                SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
                prefs.edit().putInt(MainActivity.PREF_BADGE_COUNT, badge).apply();
            }
        }
    }

    private Bitmap getThumbnail(Uri uri) {
        InputStream input = null;
        try {
            input = context.getContentResolver().openInputStream(uri);
            return BitmapFactory.decodeStream(input);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            assert input != null;

            try {
                input.close();
            } catch (IOException ignored) {
            }
        }
        return null;
    }

    private void deliveryReport(String messageId) {

        final boolean autoDelivery;

        if (mPrefs == null) {
            mPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        }

        autoDelivery = mPrefs.getBoolean(MainActivity.PREF_AUTO_DELIVERY, false);

        if (autoDelivery) {
            ScgClient.getInstance().confirm(messageId, ScgState.DELIVERED, new ScgCallback() {
                @Override
                public void onSuccess(int code, String message) {

                }

                @Override
                public void onFailed(int code, String message) {

                }
            });
        }
    }
}
