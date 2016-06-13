package com.softavail.scg.push.sdk;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

/**
 * Created by lekov on 6/12/16.
 */
public final class ScgMessagingService extends FirebaseMessagingService {
    private static final String TAG = "SCGMessagingService";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        Log.d(TAG, "From: " + remoteMessage.getFrom());
        Log.d(TAG, "Notification Message Body: " + remoteMessage.getNotification().getBody());

        if (remoteMessage.getData().containsKey("scg-message-id")) {
            final String delivery = remoteMessage.getData().get("scg-message-id");
            final ScgClient.PushNotificationListener listener = ScgClient.getInstance().getPushNotificationListener();

            if (listener != null) {
                listener.onNotificationReceived(delivery);
            }
        } else {
            // TODO: Log receiving push that cannot contains message id for delivery confirmation
        }
    }
}
