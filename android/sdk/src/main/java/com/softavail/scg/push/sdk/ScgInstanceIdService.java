package com.softavail.scg.push.sdk;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

/**
 * Created by lekov on 6/12/16.
 */
public final class ScgInstanceIdService extends FirebaseInstanceIdService {

    private static final String TAG = "ScgInstanceIdService";

    @Override
    public void onTokenRefresh() {
        final String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        final ScgClient.PushTokenListener listener = ScgClient.getInstance().getPushTokenListener();

        if (listener != null) {
            listener.onPushTokenRefreshed(refreshedToken);
        }
    }
}
