
package com.syniverse.scg.push;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.syniverse.scg.push.sdk.ScgCallback;
import com.syniverse.scg.push.sdk.ScgClient;
import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgState;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;


public class CordovaScgClient extends CordovaPlugin {

    private final Gson fGson = new Gson();


    static private ArrayList<ScgMessage> pendingMessages = null;
    static private CallbackContext notificationCallback;
    static private CallbackContext refreshTokenCallback;

    @Override
    protected void pluginInitialize() {
        //check the current intent if a notification is clicked
        Intent launchIntent = this.cordova.getActivity().getIntent();
        if ((launchIntent.getFlags() & Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0) {
            //launched from history - already processed
            return;
        }
        final Bundle extras = launchIntent.getExtras();
        this.cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                if (extras != null && extras.size() > 1) {
                    ScgMessage message = ScgMessage.from(extras);
                    if (message != null) {
                        if (pendingMessages == null) {
                            pendingMessages = new ArrayList<ScgMessage>();
                        }
                        pendingMessages.add(message);
                    }
                }
            }
        });
    }


    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if (!ScgClient.isInitialized()) {
            if ("cdv_start".equalsIgnoreCase(action)) {
                ScgClient.initialize(cordova.getActivity().getApplicationContext(), args.getString(2), args.getString(1), -1, -1);
            } else {
                return false;
            }
        } 

        final ScgClient client = ScgClient.getInstance();
        final ScgCallback result = new ScgCallback() {
            @Override
            public void onSuccess(int i, String s) {
                final JSONObject obj = new JSONObject();

                try {
                    obj.put("code", i);
                    obj.put("message", s);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                callbackContext.success(obj);
            }

            @Override
            public void onFailed(int i, String s) {
                final JSONObject obj = new JSONObject();

                try {
                    obj.put("code", i);
                    obj.put("message", s);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                callbackContext.error(obj);
            }
        };

        switch (action) {
            case "cdv_start":
            case "cdv_authenticate":
                client.auth(args.getString(0));
                callbackContext.success();
                return true;
            case "cdv_getToken":
                String token = client.getToken();
                callbackContext.success(token);
                return true;
            case "cdv_registerPushToken":
                client.registerPushToken(args.getString(0), result);
                return true;
            case "cdv_unregisterPushToken":
                client.unregisterPushToken(args.getString(0), result);
                return true;
            case "cdv_onnotification":
                onNotificationCalled(callbackContext);
                return true;
            case "cdv_ontokenrefresh":
                refreshTokenCallback = callbackContext;
                return true;
            case "cdv_reportStatus":
                client.confirm(args.getString(0), ScgState.valueOf(args.getString(1)), result);
                return true;
            case "cdv_resolveTrackedLink":
                client.resolveTrackedLink(args.getString(0), result);
                return true;
            case "cdv_loadAttachment":
                new ScgClient.DownloadAttachment(cordova.getActivity().getApplicationContext()) {
                    @Override
                    protected void onPreExecute() {

                    }

                    @Override
                    protected void onResult(String s, Uri uri) {
                        callbackContext.success();
                    }

                    @Override
                    protected void onFailed(int i, String s) {
                        callbackContext.error(s);
                    }
                }.execute(args.getString(0), args.getString(1));
                return true;
            case "cdv_resetBadge":
                client.resetBadgesCounter(args.getString(0), result);
                return true;
            case "cdv_deleteAllInboxMessages":
                client.deleteAllInboxMessages();
                return true;
            case "cdv_deleteInboxMessage":
                client.deleteInboxMessage(args.getString(0));
                return true;
            case "cdv_deleteInboxMessageAtIndex":
                client.deleteInboxMessageAtIndex(args.getInt(0));
                return true;
            case "cdv_getAllInboxMessages": {
                final List<ScgMessage> messages = client.getAllInboxMessages();

                final Type type = new TypeToken<List<ScgMessage>>() {
                }.getType();
                final JSONArray jsonArray = new JSONArray(fGson.toJson(messages, type));

                callbackContext.success(jsonArray);
                return true;
            }
            case "cdv_getInboxMessageAtIndex": {
                final ScgMessage message = client.getInboxMessageAtIndex(args.getInt(0));

                if (message != null) {
                    callbackContext.success(message.toJson());
                } else {
                    callbackContext.error(0);
                }

                return true;
            }
            case "cdv_getInboxMessagesCount":
                int messagesCount = client.getInboxMessagesCount();
                callbackContext.success(messagesCount);
                return true;
        }

        return super.execute(action, args, callbackContext);
    }

    private void onNotificationCalled(CallbackContext callbackContext) {
        notificationCallback = callbackContext;

        if (callbackContext != null && pendingMessages != null) {
            for (ScgMessage message : pendingMessages) {
                sendNotification(message);
            }
            pendingMessages.clear();
        }
    }

    static void sendNotification(ScgMessage scgMessage) {
        if (notificationCallback == null) {
            if (pendingMessages == null) {
                pendingMessages = new ArrayList<ScgMessage>();
            }
            pendingMessages.add(scgMessage);
            return;
        }
        final CallbackContext callbackContext = notificationCallback;
        if (callbackContext != null ) {
            JSONObject json = scgMessage.toJson();
            if (json == null) {
                callbackContext.error("");
                return;
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, json);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

    static void sendTokenRefreshed(String token) {
        if (refreshTokenCallback != null) {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, token);
            pluginResult.setKeepCallback(true);
            refreshTokenCallback.sendPluginResult(pluginResult);
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        final Bundle extras = intent.getExtras();
        if (extras != null && extras.size() > 1) {
            ScgMessage message = ScgMessage.from(extras);
            if (message != null) {
                sendNotification(message);
            }
        }
    }

    @Override
    public void onReset() {
        refreshTokenCallback = null;
        notificationCallback = null;
    }

}
