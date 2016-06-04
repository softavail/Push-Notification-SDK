package com.softavail.scg.push.sdk;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by lekov on 6/4/16.
 */
public class SCGRestManager {

    public static final String API = "http://95.158.130.102:8080/scg-external-api/api/v1/";
    public static final String PROXY = " http://95.158.130.102:8080/scg-dra/proxy/";

    public static SCGRestService getService(final String accessToken, final String uri) {

        Retrofit.Builder retrofit = new Retrofit.Builder()
                .baseUrl(uri)
                .addConverterFactory(GsonConverterFactory.create());

        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        httpClient.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                Request.Builder request = original.newBuilder()
                        .header("Accept", "application/json")
                        .header("Content-Type", "application/json")
                        .method(original.method(), original.body());

                if (accessToken != null) {
                    request.header("Authorization", "Bearer " + accessToken);
                }

                return chain.proceed(request.build());
            }
        });

        OkHttpClient client = httpClient.build();
        retrofit.client(client);

        return retrofit.build().create(SCGRestService.class);
    }

}
