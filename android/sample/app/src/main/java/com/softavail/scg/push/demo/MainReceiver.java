package com.softavail.scg.push.demo;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;
import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;
import com.softavail.scg.push.sdk.ScgPushReceiver;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import static java.security.AccessController.getContext;

/**
 * Created by lekov on 7/7/16.
 */
public class MainReceiver extends ScgPushReceiver {

    public static final String MESSAGE_ID = "com.softavail.scg.push.demo.extra.ID";
    public static final String MESSAGE = "com.softavail.scg.push.demo.extra.MESSAGE";
    private static final String TAG = "MainReceiver";
    SharedPreferences mPrefs;

    @Override
    protected void onPushTokenReceived(String token) {
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
    protected void onMessageReceived(final String messageId, RemoteMessage message) {

        deliveryReport(messageId);

        final String msg = message.getData().get(MESSAGE_BODY);

        Intent intent = new Intent(context, MainActivity.class);
        intent.putExtra(MESSAGE_ID, messageId);
        intent.putExtra(MESSAGE, message);
        intent.setAction(Long.toString(System.currentTimeMillis()));
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        final NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("SCG Message")
                .setContentText(msg)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setTicker(String.format("%s: %s", "SCG Message", msg))
                .setContentIntent(pendingIntent);

        final NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(messageId.hashCode(), notificationBuilder.build());


        if (message.getData().containsKey(ScgPushReceiver.MESSAGE_ATTACHMENT_ID) && message.getData().get(ScgPushReceiver.MESSAGE_ATTACHMENT_ID) != null) {
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

                    notificationBuilder.addAction(0, "Open attachment", PendingIntent.getActivity(context, 0, attachmentIntent, PendingIntent.FLAG_UPDATE_CURRENT));
                    notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                }

                @Override
                protected void onFailed(int code, String error) {
                    Log.e(TAG, "onPostExecute: Cannot download attachment");
                    notificationBuilder.setProgress(0, 0, false);
                    notificationManager.notify(messageId.hashCode(), notificationBuilder.build());
                }
            }.execute(messageId, message.getData().get(ScgPushReceiver.MESSAGE_ATTACHMENT_ID));
        }

        abortBroadcast();
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
            ScgClient.getInstance().deliveryConfirmation(messageId, new ScgCallback() {
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
