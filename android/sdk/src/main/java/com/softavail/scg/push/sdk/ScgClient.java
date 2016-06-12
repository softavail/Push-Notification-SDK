package com.softavail.scg.push.sdk;

import android.content.Context;

import com.google.firebase.iid.FirebaseInstanceId;
import com.softavail.scg.push.sdk.ScgRestService.RegisterRequest;
import com.softavail.scg.push.sdk.ScgRestService.UnregisterRequest;

import java.io.IOException;
import java.util.logging.Level;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by lekov on 6/12/16.
 */
public class ScgClient {

    /**
     *
     */
    public interface Result {
        /**
         *
         * @param code
         * @param message
         */
        void success(int code, String message);

        /**
         *
         * @param code
         * @param message
         */
        void failed(int code, String message);
    }

    /**
     *
     */
    public interface PushTokenListener {
        /**
         *
         * @param token
         */
        void onPushTokenRefreshed(String token);
    }

    private final Context fApplication;
    private final String fAppId;
    private final String fApiUrl;

    PushTokenListener mPushTokenListener;
    private ScgRestService mService;

    private static ScgClient sInstance;
    private static Level sLevel;

    private ScgClient(Context application, String rootUrl, String appId) {
        fApplication = application;
        fAppId = appId;
        fApiUrl = rootUrl;
        mService = getService(null);
    }

    /**
     *
     * @param context
     * @param rootUrl
     * @param appId
     */
    public static void initialize(Context context, String rootUrl, String appId) {
        Context application = context.getApplicationContext();

        if (sInstance == null) {
            sInstance = new ScgClient(application, rootUrl, appId);
        }
    }

    /**
     *
     * @param accessToken
     */
    public void auth(String accessToken) {
        mService = getInstance().getService(accessToken);
    }

    /**
     *
     * @return
     */
    public static ScgClient getInstance() {
        if (sInstance == null) {
            throw new IllegalAccessError("SCG client is not initialized. Please call initialize() method on ScgClient");
        }
        return sInstance;
    }

    /**
     *
     * @param level
     */
    public static void setLogLevel(Level level) {
        sLevel = level;
    }

    private ScgRestService getService(final String accessToken) {
        Retrofit.Builder retrofit = new Retrofit.Builder()
                .baseUrl(fApiUrl)
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
        mService.deliveryConfirmation(messageId);
    }

    /**
     *
     * @param pushToken
     * @param result
     */
    public void registerPushToken(final String pushToken, final Result result) {
        if (pushToken == null) return;

        final RegisterRequest request = new RegisterRequest(fAppId, pushToken);

        mService.registerPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                if (response.code() > 400) {
                    if (result != null) result.failed(response.code(), response.message());
                } else {
                    if (result != null) result.success(response.code(), response.message());
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.failed(-1, t.getMessage());
            }
        });
    }

    /**
     *
     * @param pushToken
     * @param result
     */
    public void unregisterPushToken(final String pushToken, final Result result) {
        if (pushToken == null) return;
        final UnregisterRequest request = new UnregisterRequest(pushToken);

        mService.unregisterPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                if (response.code() > 400) {
                    if (result != null) result.failed(response.code(), response.message());
                } else {
                    if (result != null) result.success(response.code(), response.message());
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.failed(-1, t.getMessage());
            }
        });
    }

    /**
     *
     * @return
     */
    public String getToken() {
        return FirebaseInstanceId.getInstance().getToken();
    }

    /**
     *
     * @param listener
     */
    public void setListener(PushTokenListener listener) {
        mPushTokenListener = listener;
    }

    PushTokenListener getListener() {
        return mPushTokenListener;
    }
}
