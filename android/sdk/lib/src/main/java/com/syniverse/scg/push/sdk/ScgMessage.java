package com.syniverse.scg.push.sdk;

import android.os.Build;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.Set;

/**
 * Created by lekov on 11/17/16.
 */

public class ScgMessage implements Parcelable {

    static final String MESSAGE_BODY = "body";
    static final String MESSAGE_ID = "scg-message-id";
    static final String MESSAGE_DEEP_LINK = "deep_link";
    static final String MESSAGE_APP_DATA = "app_data";
    static final String MESSAGE_ATTACHMENT_ID = "scg-attachment-id";
    static final String MESSAGE_SHOW_NOTIFICATION = "show-notification";
    static final String MESSAGE_TIME_RECEIVED = "received_time";
    static final String MESSAGE_BADGE = "badge";

    private final Bundle data;

    static ScgMessage from(RemoteMessage message) {
        return new ScgMessage(message);
    }

    static public ScgMessage from(Bundle message) {
        if (message.containsKey(MESSAGE_ID)) {
            return new ScgMessage(message);
        }
        return null;
    }

    private ScgMessage(RemoteMessage message) {
        data = new Bundle();
        for (Map.Entry<String, String> entry : message.getData().entrySet()) {
            data.putString(entry.getKey(), entry.getValue());
        }
        data.putLong(MESSAGE_TIME_RECEIVED, System.currentTimeMillis());
    }

    private ScgMessage(Bundle bundle) {
        this.data = bundle;
    }

    /**
     * Get message body
     *
     * @return Returns message body
     */
    public String getBody() {
        return data.getString(MESSAGE_BODY);
    }

    /**
     * Get message id
     *
     * @return Returns message id
     */
    public String getId() {
        return data.getString(MESSAGE_ID);
    }

    /**
     *
     * Check if message contains attachment
     *
     * @return Returns true if message contains attachment, false otherwise
     */
    public boolean hasAttachment() {
        return data.containsKey(MESSAGE_ATTACHMENT_ID);
    }

    /**
     * Get attachment id of this message
     *
     * @return Returns attachment id of this message
     */
    public String getAttachment() {
        return data.getString(MESSAGE_ATTACHMENT_ID);
    }

    /**
     * Check whatever this message contains a deeplink
     *
     * @return Returns true if message contains deeplink, false otherwise
     */
    public boolean hasDeepLink() {
        return data.containsKey(MESSAGE_DEEP_LINK);
    }

    /**
     * Get message deeplink data
     *
     * @return Returns message deeplink
     */
    public String getDeepLink() {
        return data.getString(MESSAGE_DEEP_LINK);
    }

    /**
     * Check whatever this message contains a appdata
     *
     * @return Returns true if message contains appdata, false otherwise
     */
    public boolean hasAppData() {
        return data.containsKey(MESSAGE_APP_DATA);
    }

    /**
     * Get message appdata data
     *
     * @return Returns message appdata
     */
    public String getAppData() {
        return data.getString(MESSAGE_APP_DATA);
    }

    /**
     * Check whatever this message will behave like an inbox
     *
     * @return Returns true if current message is inbox, false otherwise
     */
    public boolean isInbox() {
        return "false".equalsIgnoreCase(data.getString(MESSAGE_SHOW_NOTIFICATION));
    }

    /**
     * Get received UTC time of the message
     *
     * @return Returns UTC time of receive
     */
    public long getReceivedTimeUtc() {
        return data.getLong(MESSAGE_TIME_RECEIVED);
    }

    /**
     *
     * Get badge count in case this message behave as a inbox
     *
     * @return Returns the badge count
     */
    public int getBadge() {
        if (!data.containsKey(MESSAGE_BADGE)) {
            return -1;
        }

        int badge = 0;
        try {
            badge = Integer.parseInt(data.getString(MESSAGE_BADGE));
        } catch (Exception e) {
            badge = -1;
        }

        return badge;
    }

    @Override
    public String toString() {
        return data.toString();
    }

    public JSONObject toJson() {
        JSONObject json = new JSONObject();
        Set<String> keys = data.keySet();
        for (String key : keys) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    json.put(key, JSONObject.wrap(data.get(key)));
                } else {
                    json.put(key, data.get(key));
                }
            } catch(JSONException e) {
                return null;
            }
        }

        return json;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeBundle(this.data);
    }

    protected ScgMessage(Parcel in) {
        this.data = in.readBundle(getClass().getClassLoader());
    }

    public static final Parcelable.Creator<ScgMessage> CREATOR = new Parcelable.Creator<ScgMessage>() {
        @Override
        public ScgMessage createFromParcel(Parcel source) {
            return new ScgMessage(source);
        }

        @Override
        public ScgMessage[] newArray(int size) {
            return new ScgMessage[size];
        }
    };
}
