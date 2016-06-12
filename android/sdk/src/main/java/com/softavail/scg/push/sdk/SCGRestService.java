package com.softavail.scg.push.sdk;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;
import retrofit2.http.Path;

/**
 * Created by lekov on 6/4/16.
 */
public interface ScgRestService {

    String API = " http://95.158.130.102:8080/scg-dra/proxy/";

    class RegisterRequest {
        final String app_id;
        final String type;
        final String token;

        public RegisterRequest(String app_id, String token) {
            this.app_id = app_id;
            this.type = "GCM";
            this.token = token;
        }
    }

    class UnregisterRequest {
        final String token;
        final String type;

        public UnregisterRequest(String token) {
            this.token = token;
            type = "GCM";
        }
    }

    @POST("push_tokens/register")
    Call<ResponseBody> registerPushToken(@Body RegisterRequest request);

    @POST("push_tokens/unregister")
    Call<ResponseBody> unregisterPushToken(@Body UnregisterRequest request);

    @POST("messages/{message_id}/delivery_confirmation")
    Call<ResponseBody> deliveryConfirmation(@Path("message_id") String messageId);
}
