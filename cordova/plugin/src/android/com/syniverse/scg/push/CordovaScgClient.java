
package com.syniverse.scg.push;

import android.net.Uri;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.syniverse.scg.push.sdk.ScgCallback;
import com.syniverse.scg.push.sdk.ScgClient;
import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgState;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.List;


public class CordovaScgClient extends CordovaPlugin {

    private final Gson fGson = new Gson();

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
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
                callbackContext.success();
                return true;
            case "cdv_getToken":
                String token = client.getToken();
                callbackContext.success(token);
                return true;
            case "cdv_authenticate":
                client.auth(args.getString(0));
                callbackContext.success();
                return true;
            case "cdv_registerPushToken":
                client.registerPushToken(args.getString(0), result);
                return true;
            case "cdv_unregisterPushToken":
                client.unregisterPushToken(args.getString(0), result);
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

                final Type type = new TypeToken<ScgMessage>() {
                }.getType();
                final JSONObject jsonObject = new JSONObject(fGson.toJson(message, type));

                callbackContext.success(jsonObject);
                return true;
            }
            case "cdv_getInboxMessagesCount":
                int messagesCount = client.getInboxMessagesCount();
                callbackContext.success(messagesCount);
                return true;
        }

        return super.execute(action, args, callbackContext);
    }
}
