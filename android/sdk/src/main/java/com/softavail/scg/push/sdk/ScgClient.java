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

    private final Context fApplication;
    private final String fAppId;
    private final String fApiUrl;

    ScgListener mListener;
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
     * @param accessToken
     */
    public void auth(String accessToken) {
        mService = getInstance().getService(accessToken);
    }

    /**
     * @return
     */
    public static ScgClient getInstance() {
        if (sInstance == null) {
            throw new IllegalAccessError("SCG client is not initialized. Please call initialize() method on ScgClient");
        }
        return sInstance;
    }

    /**
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

    public void deliveryConfirmation(String messageId, final ScgCallback result) {
        if (messageId == null) return;
        mService.deliveryConfirmation(messageId).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                if (response.code() > 400) {
                    if (result != null) result.onFailed(response.code(), response.message());
                } else {
                    if (result != null) result.onSuccess(response.code(), response.message());
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.onFailed(-1, t.getMessage());
            }
        });
    }

    /**
     * @param pushToken
     * @param result
     */
    public void registerPushToken(final String pushToken, final ScgCallback result) {
        if (pushToken == null) return;

        final RegisterRequest request = new RegisterRequest(fAppId, pushToken);

        mService.registerPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                if (response.code() > 400) {
                    if (result != null) result.onFailed(response.code(), response.message());
                } else {
                    if (result != null) result.onSuccess(response.code(), response.message());
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.onFailed(-1, t.getMessage());
            }
        });
    }

    /**
     * @param pushToken
     * @param result
     */
    public void unregisterPushToken(final String pushToken, final ScgCallback result) {
        if (pushToken == null) return;
        final UnregisterRequest request = new UnregisterRequest(pushToken);

        mService.unregisterPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                if (response.code() > 400) {
                    if (result != null) result.onFailed(response.code(), response.message());
                } else {
                    if (result != null) result.onSuccess(response.code(), response.message());
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.onFailed(-1, t.getMessage());
            }
        });
    }

    /**
     * @return
     */
    public String getToken() {
        return FirebaseInstanceId.getInstance().getToken();
    }

    ScgListener getListener() {
        return mListener;
    }

    public void setListener(ScgListener listener) {
        mListener = listener;
    }
}
