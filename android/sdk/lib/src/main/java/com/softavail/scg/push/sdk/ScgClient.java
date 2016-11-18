package com.softavail.scg.push.sdk;

import android.content.Context;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;
import com.softavail.scg.push.sdk.ScgRestService.RegisterRequest;
import com.softavail.scg.push.sdk.ScgRestService.UnregisterRequest;

import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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

    private static final String TAG = "ScgClient";

    private final String fAppId;
    private final String fApiUrl;

    private ScgRestService mService;

    private static ScgClient sInstance;
    private String mAuthToken;


    private ScgClient(Context application, String rootUrl, String appId) {
        fAppId = appId;
        fApiUrl = rootUrl;
        mService = getService();
    }

    /**
     * Initialize library
     *
     * @param context Context to be initialized with
     * @param rootUrl Root URL of the API
     * @param appId   Application ID
     */
    public static void initialize(Context context, String rootUrl, String appId) {
        Context application = context.getApplicationContext();

        if (sInstance == null) {
            sInstance = new ScgClient(application, rootUrl, appId);
        }
    }

    public static boolean isInitialized() {
        return sInstance != null;
    }

    /**
     * Authenticate in front of the API
     *
     * @param accessToken Access token using for authentitacion
     */
    public void auth(String accessToken) {

        if (mAuthToken != null && mAuthToken.equals(accessToken)) {
            return;
        }

        mAuthToken = accessToken;
    }


    /**
     * Get authentication token
     *
     * @return Returns the authentication token
     */
    public String getAuthToken() {
        return mAuthToken;
    }

    /**
     * Get library instance
     *
     * @return Returns instance of the library
     */
    public static ScgClient getInstance() {
        if (sInstance == null) {
            throw new IllegalAccessError("SCG client is not initialized. Please call initialize() method on ScgClient");
        }
        return sInstance;
    }


    private ScgRestService getService() {

        Retrofit.Builder retrofit = new Retrofit.Builder()
                .baseUrl(fApiUrl)
                .addConverterFactory(GsonConverterFactory.create())
                .client(getClient(true, true));

        return retrofit.build().create(ScgRestService.class);
    }

    private OkHttpClient getClient(boolean withAuthorization, boolean followRedirects) {
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();

        if (withAuthorization)
            httpClient.addInterceptor(new Interceptor() {
                @Override
                public Response intercept(Chain chain) throws IOException {
                    Request original = chain.request();
                    Request.Builder request = original.newBuilder()
                            .headers(original.headers())
                            .method(original.method(), original.body());

                    if (mAuthToken != null) {
                        request.header("Authorization", "Bearer " + mAuthToken);
                    }

                    return chain.proceed(request.build());
                }
            });

        httpClient.followRedirects(followRedirects);
        httpClient.followSslRedirects(followRedirects);
        return httpClient.build();
    }

    private OkHttpClient getClient(boolean withAuthorization) {
        return getClient(withAuthorization, false);
    }

    /**
     * Confirm state of message
     *
     * @param messageId ID of the message to be confirm
     * @param state     Message state to be confirm
     * @param result    Callback getting the result of the confirmation
     * @see ScgState
     */
    public synchronized void confirm(String messageId, ScgState state, final ScgCallback result) {
        if (messageId == null) return;
        mService.confirmation(messageId, state).enqueue(new Callback<ResponseBody>() {
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
     * Register device push token
     *
     * @param pushToken The device push token
     * @param result    Callback getting the result of the register call
     */
    public synchronized void registerPushToken(final String pushToken, final ScgCallback result) {
        if (pushToken == null) return;

        final RegisterRequest request = new RegisterRequest(fAppId, pushToken);

        mService.registerPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                sendResult(response, result);
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.onFailed(-1, t.getMessage());
            }
        });
    }

    /**
     * Unregister device push token
     *
     * @param pushToken The device push token
     * @param result    Callback getting the result of the unregister call
     */
    public synchronized void unregisterPushToken(final String pushToken, final ScgCallback result) {
        if (pushToken == null) return;

        final UnregisterRequest request = new UnregisterRequest(fAppId, pushToken);

        mService.unregisterPushToken(request).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                sendResult(response, result);
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                result.onFailed(-1, t.getMessage());
            }
        });
    }

    public synchronized void resolveTrackedLink(String url, final ScgCallback result) {

        final Request.Builder r = new Request.Builder()
                .url(url)
                .head();

        ScgClient.getInstance().getClient(false).newCall(r.build()).enqueue(new okhttp3.Callback() {
            @Override
            public void onFailure(okhttp3.Call call, IOException e) {
                result.onFailed(-1, e.getMessage());
            }

            @Override
            public void onResponse(okhttp3.Call call, Response response) throws IOException {
                sendRedirectResult(response, result);
            }
        });
    }

    private void sendRedirectResult(Response response, ScgCallback result) {
        if (result == null) return;

        if (response.isRedirect()) {
            Log.i(TAG, "sendRedirectResult: Resolved URL is " + response.headers().get("Location"));
            result.onSuccess(response.code(), response.headers().get("Location"));
        } else {
            result.onFailed(response.code(), "Link cannot be tracked");
        }
    }

    private void sendResult(retrofit2.Response<ResponseBody> response, ScgCallback result) {
        if (response.code() > 400) {
            if (result == null) return;

            try {
                JSONObject obg = new JSONObject(response.errorBody().string());
                result.onFailed(obg.getInt("code"), obg.getString("description"));
            } catch (Exception ignored) {
                result.onFailed(response.code(), response.message());
            }
        } else {
            if (result != null) result.onSuccess(response.code(), response.message());
        }
    }

    /**
     * Get device push token
     *
     * @return Returns device push token
     */
    public String getToken() {
        return FirebaseInstanceId.getInstance().getToken();
    }


    /**
     * Download attachment async
     * <p>
     * You must pass to execute 2 strings: MessageId and AttachmentId
     */
    public static abstract class DownloadAttachment extends AsyncTask<String, Void, Uri> {

        private final ScgClient client;
        private final Context fContext;

        private String mimeType;

        private int errorCode = 0;
        private String errorMessage = null;

        public DownloadAttachment(Context context) {
            client = ScgClient.getInstance();
            fContext = context;
        }

        @Override
        protected abstract void onPreExecute();

        /**
         * Result download callback
         *
         * @param mimeType Mime type of the downloaded attachment
         * @param result   URI to the downloaded attachment
         */
        protected abstract void onResult(String mimeType, Uri result);

        /**
         * Failure download callback
         *
         * @param code  Error code - HTTP code or -1 for writing the attachment ot storage
         * @param error Error message - Returned from the server error or exception message
         */
        protected abstract void onFailed(int code, String error);


        /**
         * @param strings Strings of message ID and attachment ID
         * @return Returns URI to the downloaded attachment
         */
        @Override
        protected Uri doInBackground(String... strings) {
            if (strings.length != 2 || strings[0] == null || strings[1] == null) {
                throw new IllegalArgumentException();
            }

            Log.d(TAG, "doInBackground: downloading " + strings[1] + " attachment of " + strings[0]);

            try {
                final retrofit2.Response<ResponseBody> res = client.getService().downloadAttachment(strings[0], strings[1]).execute();

                if (res.isSuccessful()) {
                    mimeType = res.body().contentType().type() + "/" + res.body().contentType().subtype();
                    final String extension = res.body().contentType().subtype();

                    Log.i(TAG, "doInBackground: " + mimeType);
                    Log.i(TAG, "doInBackground: " + extension);

                    return writeResponseBodyToDisk(res.body(), String.format("%s-%s.%s", strings[0], strings[1], extension));
                } else {
                    errorCode = res.code();
                    errorMessage = res.errorBody().string();
                    Log.e(TAG, "doInBackground: " + errorCode + " -> " + errorMessage);
                }
            } catch (IOException e) {
                errorCode = -1;
                errorMessage = e.getLocalizedMessage();
                Log.e(TAG, "doInBackground: ", e);
            }

            return null;
        }

        @Override
        protected void onPostExecute(Uri attachment) {
            if (errorMessage == null && attachment != null) {
                onResult(mimeType, attachment);
            } else {
                onFailed(errorCode, errorMessage);
            }
        }

        private Uri writeResponseBodyToDisk(ResponseBody body, String filename) {
            try {
                final File file = new File(fContext.getExternalFilesDir(null), filename);

                InputStream inputStream = null;
                OutputStream outputStream = null;

                try {
                    byte[] fileReader = new byte[4096];

                    inputStream = body.byteStream();
                    outputStream = new FileOutputStream(file);

                    while (true) {
                        int read = inputStream.read(fileReader);

                        if (read == -1) {
                            break;
                        }

                        outputStream.write(fileReader, 0, read);
                    }

                    outputStream.flush();

                    return Uri.fromFile(file);
                } catch (IOException e) {
                    return null;
                } finally {
                    if (inputStream != null) {
                        inputStream.close();
                    }

                    if (outputStream != null) {
                        outputStream.close();
                    }
                }
            } catch (IOException e) {
                return null;
            }
        }
    }
}
