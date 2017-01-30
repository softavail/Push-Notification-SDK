package com.softavail.scg.push.sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.google.firebase.messaging.RemoteMessage;

/**
 * Created by lekov on 7/7/16.
 */
public abstract class ScgPushReceiver extends BroadcastReceiver {

    public static final String ACTION_PUSH_TOKEN_RECEIVED = "com.softavail.scg.push.sdk.action.PUSH_TOKEN_RECEIVED";
    public static final String ACTION_MESSAGE_RECEIVED = "com.softavail.scg.push.sdk.action.MESSAGE_RECEIVED";

    public static final String EXTRA_TOKEN = "com.softavail.scg.push.sdk.extra.TOKEN";
    public static final String EXTRA_MESSAGE = "com.softavail.scg.push.sdk.extra.MESSAGE";

    public static final String MESSAGE_BODY = "body";
    public static final String MESSAGE_ID = "scg-message-id";
    public static final String MESSAGE_ATTACHMENT_ID = "scg-attachment-id";

    protected Context context;

    @Override
    public final void onReceive(Context context, Intent intent) {
        this.context = context;

        if (ACTION_PUSH_TOKEN_RECEIVED.equals(intent.getAction())) {

            if (intent.hasExtra(EXTRA_TOKEN)) {
                final String token = intent.getStringExtra(EXTRA_TOKEN);
                onPushTokenReceived(token);
            }
        } else if (ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {

            if (intent.hasExtra(EXTRA_MESSAGE)) {
                final RemoteMessage message = intent.getParcelableExtra(EXTRA_MESSAGE);
                final String delivery = message.getData().get(MESSAGE_ID);
                onMessageReceived(delivery, message);
            }
        }
    }

    protected abstract void onPushTokenReceived(String token);
    protected abstract void onMessageReceived(String messageId, RemoteMessage message);
}
