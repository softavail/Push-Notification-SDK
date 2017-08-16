package com.syniverse.scg.push;

import android.content.SharedPreferences;
import android.util.Log;

import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgPushReceiver;

/**
 * Created by lekov on 7/7/16.
 */
public class MainReceiver extends ScgPushReceiver {

    private static final String TAG = "ScgPushReceiverCordova";
    SharedPreferences mPrefs;

    @Override
    protected void onPushTokenReceived(String token) {
        Log.v(TAG, "onPushTokenReceived() " + token);
        CordovaScgClient.sendTokenRefreshed(token);
    }

    @Override
    protected void onMessageReceived(final String messageId, final ScgMessage message) {
        if (messageId == null) {
            Log.v(TAG, "onMessageReceived() called with: messageId = [" + messageId + "], so message was not handled.");
            return;
        }
        CordovaScgClient.sendNotification(message);
    }

}
