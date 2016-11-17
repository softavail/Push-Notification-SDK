package com.softavail.scg.push.sdk;

import android.net.Uri;

import java.net.URL;

import okhttp3.Request;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.HEAD;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Streaming;

/**
 * Created by lekov on 6/4/16.
 */
interface ScgRestService {

    enum State {
        DELIVERED, MEDIA_REQUESTED, READ, CLICKTHRU, CONVERTED;
    }

    class RegisterRequest {
        final String app_id;
        final String type;
        final String token;

        RegisterRequest(String app_id, String token) {
            this.app_id = app_id;
            this.type = "GCM";
            this.token = token;
        }
    }

    class UnregisterRequest {
        final String app_id;
        final String token;
        final String type;

        UnregisterRequest(String app_id, String token) {
            this.app_id = app_id;
            this.token = token;
            this.type = "GCM";
        }
    }

    @Headers({
            "Accept:application/json",
            "Content-Type:application/json"
    })
    @POST("push_tokens/register")
    Call<ResponseBody> registerPushToken(@Body RegisterRequest request);

    @Headers({
            "Accept:application/json",
            "Content-Type:application/json"
    })
    @POST("push_tokens/unregister")
    Call<ResponseBody> unregisterPushToken(@Body UnregisterRequest request);

    @Headers({
            "Accept:application/json",
            "Content-Type:application/json"
    })
    @POST("messages/{message_id}/delivery_confirmation")
    Call<ResponseBody> deliveryConfirmation(@Path("message_id") String messageId);

    @Headers({
            "Accept:application/json",
            "Content-Type:application/json"
    })
    @POST("messages/{message_id}/click_thru_confirmation")
    Call<ResponseBody> interactionConfirmation(@Path("message_id") String messageId);

    @Headers({
            "Accept:application/json",
            "Content-Type:application/json"
    })
    @POST("messages/{message_id}/confirm/{type_of}")
    Call<ResponseBody> confirmation(@Path("message_id") String messageId, @Path("type_of") State typeOf);

    @Streaming
    @GET("attachment/{message_id}/{attachment_id}")
    Call<ResponseBody> downloadAttachment(@Path("message_id") String messageId, @Path("attachment_id") String attachment_id);
}
