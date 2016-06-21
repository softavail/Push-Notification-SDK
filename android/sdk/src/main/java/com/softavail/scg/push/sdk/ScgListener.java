package com.softavail.scg.push.sdk;

import com.google.firebase.messaging.RemoteMessage;

/**
 * Created by lekov on 6/15/16.
 */
public interface ScgListener {
    void onPushTokenReceived(String token);
    void onMessageReceived(String messageId, RemoteMessage message);
    void onPlayServiceError();
}
