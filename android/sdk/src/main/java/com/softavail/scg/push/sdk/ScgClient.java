package com.softavail.scg.push.sdk;

import android.content.Context;
import android.content.SharedPreferences;

import java.io.IOException;
import java.util.logging.Level;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by lekov on 6/12/16.
 */
public class ScgClient {

    public static final String PREFS_NAME = "ScgPush";

    private final Context fApplication;
    private final SharedPreferences fPreferences;
    private final String fAppId;

    private static ScgClient sInstance;
    private static ScgRestService sService;
    private static Level sLevel;

    public ScgClient(Context application, String appId) {
        fApplication = application;
        fPreferences = application.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        fAppId = appId;
        sService = getService(null);
    }

    public static void initialize(Context context, String appId) {
        Context application = context.getApplicationContext();

        if (sInstance == null) {
            sInstance = new ScgClient(application, appId);
        }
    }

    public static void auth(String accessToken) {
        sService = getInstance().getService(accessToken);
    }

    public static ScgClient getInstance() {
        if (sInstance == null) {
            throw new IllegalAccessError("SCG client is not initialized. Please call initialize() method on ScgClient");
        }
        return sInstance;
    }

    public static void setLogLevel(Level level) {
        sLevel = level;
    }

    private ScgRestService getService(final String accessToken) {
        Retrofit.Builder retrofit = new Retrofit.Builder()
                .baseUrl(ScgRestService.API)
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

        return retrofit.build().create(ScgRestService.class);
    }

    void deliveryConfirmation(String messageId) {
        sService.deliveryConfirmation(messageId);
    }

    void registerPushToken(String pushToken) {

        if (pushToken == null) return;

        if (fPreferences.contains("lastToken")) {
            unregisterPushToken(fPreferences.getString("lastToken", null));
        }

        sService.registerPushToken(new ScgRestService.RegisterRequest(fAppId, pushToken));
    }

    void unregisterPushToken(String pushToken) {
        if (pushToken == null) return;

        sService.unregisterPushToken(new ScgRestService.UnregisterRequest(pushToken));
    }
}
