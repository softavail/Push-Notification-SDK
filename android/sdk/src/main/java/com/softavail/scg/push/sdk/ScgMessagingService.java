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

        if (remoteMessage.getData().containsKey("message_id")) {
            final String delivery = remoteMessage.getData().get("message_id");
            ScgClient.getInstance().deliveryConfirmation(delivery);
        } else {
            // TODO: Log receiving push that cannot contains message id for delivery confirmation
        }
    }
}
