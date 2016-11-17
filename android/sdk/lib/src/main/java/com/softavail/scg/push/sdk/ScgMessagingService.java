package com.softavail.scg.push.sdk;

import android.content.Intent;
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
        Log.i(TAG, "Notification received");
        Log.d(TAG, remoteMessage.getData().toString());

        Intent tokenIntent = new Intent(ScgPushReceiver.ACTION_MESSAGE_RECEIVED);
        tokenIntent.putExtra(ScgPushReceiver.EXTRA_MESSAGE, ScgMessage.from(remoteMessage));

        getApplicationContext().sendOrderedBroadcast(tokenIntent, null);
    }
}
