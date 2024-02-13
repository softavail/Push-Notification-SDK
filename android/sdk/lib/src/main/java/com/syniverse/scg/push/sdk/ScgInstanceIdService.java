//package com.syniverse.scg.push.sdk;
//
//import android.content.Intent;
//
//import com.google.firebase.iid.FirebaseInstanceId;
//import com.google.firebase.iid.FirebaseInstanceIdService;
//
///**
// * Created by lekov on 6/12/16.
// */
//public final class ScgInstanceIdService extends FirebaseInstanceIdService {
//
//    private static final String TAG = "ScgInstanceIdService";
//
//    @Override
//    public void onTokenRefresh() {
//        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
//
//        Intent tokenIntent = new Intent(ScgPushReceiver.ACTION_PUSH_TOKEN_RECEIVED);
//        tokenIntent.putExtra(ScgPushReceiver.EXTRA_TOKEN, refreshedToken);
//
//        getApplicationContext().sendOrderedBroadcast(tokenIntent, null);
//    }
//}
