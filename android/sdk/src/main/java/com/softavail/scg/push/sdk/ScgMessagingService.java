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

        if (remoteMessage.getData().containsKey("scg-message-id")) {
            final String delivery = remoteMessage.getData().get("scg-message-id");
            final ScgListener listener = ScgClient.getInstance().getListener();

            if (listener != null) {
                listener.onMessageReceived(delivery, remoteMessage);
            }
        } else {
            // TODO: Log receiving push that cannot contains message id for delivery confirmation
        }
    }
}
