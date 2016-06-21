package com.softavail.scg.push.demo;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;

/**
 * Created by lekov on 6/12/16.
 */
public interface AuthService {

    String API = "http://95.158.130.102:8080/scg-external-api/api/v1/";

    class GenerateRequest {

        final int duration;

        public GenerateRequest(int duration) {
            this.duration = duration;
        }
    }

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

    Retrofit retrofit = new Retrofit.Builder()
            .baseUrl(API)
            .addConverterFactory(GsonConverterFactory.create())
            .client(new OkHttpClient.Builder().addInterceptor(new Interceptor() {
                @Override
                public Response intercept(Interceptor.Chain chain) throws IOException {
                    Request original = chain.request();
                    Request.Builder request = original.newBuilder()
                            .header("Accept", "application/json")
                            .header("Content-Type", "application/json")
                            .method(original.method(), original.body());

                    return chain.proceed(request.build());
                }
            }).build())
            .build();
}
