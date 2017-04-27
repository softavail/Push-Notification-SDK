package com.syniverse.scg.push.sdk;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

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

    static ScgMessage from(Bundle message) {
        return new ScgMessage(message);
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

    public String getBody() {
        return data.getString(MESSAGE_BODY);
    }

    public String getId() {
        return data.getString(MESSAGE_ID);
    }

    public boolean hasAttachment() {
        return data.containsKey(MESSAGE_ATTACHMENT_ID);
    }

    public String getAttachment() {
        return data.getString(MESSAGE_ATTACHMENT_ID);
    }

    public boolean hasDeepLink() {
        return data.containsKey(MESSAGE_DEEP_LINK);
    }

    public String getDeepLink() {
        return data.getString(MESSAGE_DEEP_LINK);
    }

    public boolean hasAppData() {
        return data.containsKey(MESSAGE_APP_DATA);
    }

    public String getAppData() {
        return data.getString(MESSAGE_APP_DATA);
    }

    public boolean isInbox() {
        return "false".equalsIgnoreCase(data.getString(MESSAGE_SHOW_NOTIFICATION));
    }

    public long getReceivedTimeUtc() {
        return data.getLong(MESSAGE_TIME_RECEIVED);
    }

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
