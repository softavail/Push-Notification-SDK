package com.syniverse.scg.push.sdk;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.firebase.messaging.RemoteMessage;

/**
 * Created by lekov on 11/17/16.
 */

public class ScgMessage implements Parcelable {

    static final String MESSAGE_BODY = "body";
    static final String MESSAGE_ID = "scg-message-id";
    static final String MESSAGE_DEEP_LINK = "deep_link";
    static final String MESSAGE_APP_DATA = "app_data";
    static final String MESSAGE_ATTACHMENT_ID = "scg-attachment-id";

    private final RemoteMessage fMessage;

    static ScgMessage from(RemoteMessage message) {
        return new ScgMessage(message);
    }

    private ScgMessage(RemoteMessage message) {
        fMessage = message;
    }

    public String getBody() {
        return fMessage.getData().get(MESSAGE_BODY);
    }

    public String getId() {
        return fMessage.getData().get(MESSAGE_ID);
    }

    public boolean hasAttachment() {
        return fMessage.getData().containsKey(MESSAGE_ATTACHMENT_ID);
    }

    public String getAttachment() {
        return fMessage.getData().get(MESSAGE_ATTACHMENT_ID);
    }

    public boolean hasDeepLink() {
        return fMessage.getData().containsKey(MESSAGE_DEEP_LINK);
    }

    public String getDeepLink() {
        return fMessage.getData().get(MESSAGE_DEEP_LINK);
    }

    public boolean hasAppData() {
        return fMessage.getData().containsKey(MESSAGE_APP_DATA);
    }

    public String getAppData() {
        return fMessage.getData().get(MESSAGE_APP_DATA);
    }

    @Override
    public String toString() {
        return fMessage.getData().toString();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeParcelable(this.fMessage, flags);
    }

    protected ScgMessage(Parcel in) {
        this.fMessage = in.readParcelable(RemoteMessage.class.getClassLoader());
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
