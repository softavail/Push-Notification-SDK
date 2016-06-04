package com.softavail.scg.push.sdk;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;

/**
 * Created by lekov on 6/4/16.
 */
public interface SCGRestService {

    class GenerateRequest {

        final int duration;

        public GenerateRequest(int duration) {
            this.duration = duration;
        }
    }

    class RegisterRequest {
        final String app_id;
        final String type;
        final String token;

        public RegisterRequest(String app_id, String type, String token) {
            this.app_id = app_id;
            this.type = type;
            this.token = token;
        }
    }

    class UnregisterRequest {
        final String token;

        public UnregisterRequest(String token) {
            this.token = token;
        }
    }

    @POST("push_tokens/register")
    Call<ResponseBody> registerPushToken(@Body RegisterRequest request);

    @POST("push_tokens/unregister")
    Call<ResponseBody> unregisterPushToken(@Body UnregisterRequest request);

    @POST("contacts/{client_id}/access_tokens")
    @Headers({
            "int-companyId:99999",
            "int-appId:888",
            "int-txnId: bogus-transaction-id"})
    Call<ResponseBody> generateAccessToken(@Path("client_id") String client, @Body GenerateRequest request);

    @GET("contacts")
    @Headers({
            "int-companyId:99999",
            "int-appId:888",
            "int-txnId: bogus-transaction-id"})
    Call<ResponseBody> listContacts();
}
