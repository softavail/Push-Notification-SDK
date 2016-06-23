package com.softavail.scg.push.demo;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.NotificationCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.messaging.RemoteMessage;
import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;
import com.softavail.scg.push.sdk.ScgListener;


public class MainActivity extends AppCompatActivity implements ScgListener, ScgCallback {

    private static final String TAG = "MainActivity";
    private EditText accessToken;
    private TextView pushToken;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        accessToken = (EditText) findViewById(R.id.access);
        pushToken = (TextView) findViewById(R.id.token);

        final View initView = LayoutInflater.from(this).inflate(R.layout.dialog_initialization, null, false);

        final AlertDialog.Builder init = new AlertDialog.Builder(this);
        init.setTitle("Setup SCG library")
                .setView(initView)
                .setPositiveButton("Finish", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        final String uri = ((EditText) initView.findViewById(R.id.apiUrl)).getText().toString();
                        final String appid = ((EditText) initView.findViewById(R.id.appId)).getText().toString();

                        if (TextUtils.isEmpty(uri) || TextUtils.isEmpty(appid)) {
                            Toast.makeText(MainActivity.this, "Library must be initialised properly!", Toast.LENGTH_LONG).show();
                            finish();
                            return;
                        }

                        ScgClient.initialize(MainActivity.this, uri, appid);
                        ScgClient.getInstance().setListener(MainActivity.this);
                        pushToken.setText(ScgClient.getInstance().getToken());
                    }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                Toast.makeText(MainActivity.this, "Library must be initialised!", Toast.LENGTH_LONG).show();
                finish();
            }
        }).show();
    }

    public void onTokenRegister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            final String access = accessToken.getText().toString();
            if (!TextUtils.isEmpty(access)) {
                ScgClient.getInstance().auth(access);
                ScgClient.getInstance().registerPushToken(token, this);
            } else {
                Snackbar.make(view, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
            }

        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
        }
    }

    public void onTokenUnregister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            final String access = accessToken.getText().toString();
            if (!TextUtils.isEmpty(access)) {
                ScgClient.getInstance().auth(access);
                ScgClient.getInstance().unregisterPushToken(token, this);
            } else {
                Snackbar.make(view, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
            }
        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
        }
    }

    @Override
    public void onSuccess(int code, String message) {
        Snackbar.make(pushToken, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
    }

    @Override
    public void onFailed(int code, String message) {
        Snackbar.make(pushToken, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
    }

    public void onGetToken(View view) {
        pushToken.setText(ScgClient.getInstance().getToken());
    }

    private void sendNotification(RemoteMessage remoteMessage) {

        final String message = remoteMessage.getNotification() == null ? remoteMessage.getData().get("message") : remoteMessage.getNotification().getBody();
        final String title = remoteMessage.getNotification() == null ? remoteMessage.getData().get("title") : remoteMessage.getNotification().getTitle();

        if (message == null || title == null)
            return;


        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(message)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }

    @Override
    public void onPushTokenReceived(final String token) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pushToken.setText(token);
                Snackbar.make(pushToken, "Push token refreshed", Snackbar.LENGTH_INDEFINITE).show();
            }
        });
    }

    @Override
    public void onMessageReceived(final String messageId, RemoteMessage message) {
        sendNotification(message);
        Snackbar.make(pushToken, String.format("Notification received: %s", messageId), Snackbar.LENGTH_INDEFINITE)
                .setAction("Delivery confirmation", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        final String access = accessToken.getText().toString();
                        if (!TextUtils.isEmpty(access)) {
                            ScgClient.getInstance().auth(access);
                            ScgClient.getInstance().deliveryConfirmation(messageId, MainActivity.this);
                        } else {
                            Snackbar.make(pushToken, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
                        }
                    }
                })
                .show();
    }

    @Override
    public void onPlayServiceError() {

    }
}
