package com.syniverse.scg.push.sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

//import com.google.firebase.iid.FirebaseInstanceId;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.firebase.messaging.FirebaseMessaging;
import com.syniverse.scg.push.sdk.ScgRestService.RegisterRequest;
import com.syniverse.scg.push.sdk.ScgRestService.UnregisterRequest;

import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

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

    private static final int DEFAULT_RETRY_COUNT = 5;
    //200 millis
    private static final long DEFAULT_RETRY_DELAY = 200;


    private final String fAppId;
    private final String fApiUrl;

    private ScgRestService mService;

    private static ScgClient sInstance;
    private Context mContext;
    private String mAuthToken;

    private int mRetryCount;
    private long mInitialDelay;


    private ScgClient(Context application, String rootUrl, String appId, int retryCount, long initialDelay) {
        fAppId = appId;
        fApiUrl = rootUrl;
        mService = getService();
        mContext = application;

        mRetryCount = (retryCount >= 0) ? retryCount : DEFAULT_RETRY_COUNT;
        mInitialDelay = (initialDelay >= 0) ? initialDelay : DEFAULT_RETRY_DELAY;
    }

    /**
     * Initialize library
     *
     * @param context Context to be initialized with
     * @param rootUrl Root URL of the API
     * @param appId   Application ID
     * @param retriesCount How many times the SDK should retry on 503 error code.
     * @param initialRetryDelay Sets how long the SDK should wait before resending the request. The next retry delays is doubled.
     */
    public static void initialize(Context context, String rootUrl, String appId, int retriesCount, long initialRetryDelay) {
        Context application = context.getApplicationContext();

        if (sInstance == null) {
            sInstance = new ScgClient(application, rootUrl, appId, retriesCount, initialRetryDelay);
        }
    }

    /**
     *  Check if library is initialized
     *
     * @return Returns true if library is initialized, false otherwise
     */
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

    /**
     * Destroys the currently initialized instance
     */
    public static void destroyInstance() {
        sInstance = null;
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

        //test the 503 error response
//        httpClient.interceptors().add(new Interceptor() {
//            @Override
//            public Response intercept(Chain chain) throws IOException {
//                Request request = chain.request();
//                if (request.url().toString().contains("/register")) {
//                    return chain.proceed(request);
//                }
//
//                Response response = new Response.Builder()
//                        .code(503)
//                        .message("Service unavail.")
//                        .request(chain.request())
//                        .protocol(Protocol.HTTP_1_0)
//                        .addHeader("content-type", "application/json")
//                        .body(ResponseBody.create(MediaType.parse("application/json"), new byte[0]))
//                        .build();
//
//                return response;
//            }
//        });

        httpClient.followRedirects(followRedirects);
        httpClient.retryOnConnectionFailure(true);
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
        confirm(messageId, state, result, 0, mInitialDelay);
    }

    private void confirm(final String messageId, final ScgState state, final ScgCallback result, final int retryCount, final long delay) {
        if (messageId == null) return;
        new Handler(Looper.myLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                mService.confirmation(messageId, state).enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        if (response.code() == 503 && retryCount < mRetryCount) {
                            Log.d(TAG, "confirm: 503 - retrying (" + retryCount + ")");
                            confirm(messageId, state, result, retryCount + 1, delay * 2);
                        } else if (response.code() > 400) {
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
        }, delay);
    }

    /**
     * Register device push token
     *
     * @param pushToken The device push token
     * @param result    Callback getting the result of the register call
     */
    public synchronized void registerPushToken(String pushToken, ScgCallback result) {
        registerPushToken(pushToken, result, 0, mInitialDelay);
    }

    private void registerPushToken(final String pushToken, final ScgCallback result, final int retryCount, final long delay) {
        if (pushToken == null) return;

        final RegisterRequest request = new RegisterRequest(fAppId, pushToken);

        new Handler(Looper.myLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                mService.registerPushToken(request).enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        if (response.code() == 503 && retryCount < mRetryCount) {
                            Log.d(TAG, "registerPushToken: 503 - retrying (" + retryCount + ")");
                            registerPushToken(pushToken, result, retryCount + 1, delay * 2);
                        } else {
                            sendResult(response, result);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        result.onFailed(-1, t.getMessage());
                    }
                });
            }
        }, delay);
    }

    /**
     * Unregister device push token
     *
     * @param pushToken The device push token
     * @param result    Callback getting the result of the unregister call
     */
    public synchronized void unregisterPushToken(final String pushToken, final ScgCallback result) {
        unregisterPushToken(pushToken, result, 0, mInitialDelay);
    }

    private void unregisterPushToken(final String pushToken, final ScgCallback result, final int retryCount, final long delay) {
        if (pushToken == null) return;

        final UnregisterRequest request = new UnregisterRequest(fAppId, pushToken);

        new Handler(Looper.myLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                mService.unregisterPushToken(request).enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        if (response.code() == 503 && retryCount < mRetryCount) {
                            Log.d(TAG, "unregisterPushToken: 503 - retrying (" + retryCount + ")");
                            unregisterPushToken(pushToken, result, retryCount + 1, delay * 2);
                        } else {
                            sendResult(response, result);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        result.onFailed(-1, t.getMessage());
                    }
                });
            }
        }, delay);
    }

    /**
     * Reset Badges Counter
     *
     * @param pushToken The device push token
     * @param result    Callback getting the result of the register call
     */
    public synchronized void resetBadgesCounter(String pushToken, ScgCallback result) {
        resetBadgesCounter(pushToken, result, 0, mInitialDelay);
    }

    private void resetBadgesCounter(final String pushToken, final ScgCallback result, final int retryCount, final long delay) {
        if (pushToken == null) return;

        final RegisterRequest request = new RegisterRequest(fAppId, pushToken);

        new Handler(Looper.myLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                mService.resetBadgesCounter(request).enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        if (response.code() == 503 && retryCount < mRetryCount) {
                            Log.d(TAG, "resetBadgesCounter: 503 - retrying (" + retryCount + ")");
                            resetBadgesCounter(pushToken, result, retryCount + 1, delay * 2);
                        } else {
                            sendResult(response, result);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        result.onFailed(-1, t.getMessage());
                    }
                });
            }
        }, delay);
    }

    /**
     * Resolve tracked link
     *
     * @param url URL to be resolved to real one URL
     * @param result Resolved URL
     */
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

    private void onTokenRefresh(String token) {
        Intent tokenIntent = new Intent(ScgPushReceiver.ACTION_PUSH_TOKEN_RECEIVED);
        tokenIntent.putExtra(ScgPushReceiver.EXTRA_TOKEN, token);

        mContext.sendOrderedBroadcast(tokenIntent, null);
    }


    /**
     * Check the device to make sure it has the Google Play Services APK. If it
     * doesn't, display a dialog that allows users to download the APK from the
     * Google Play Store or enable it in the device's system settings.
     */
    public boolean checkPlayServices(Activity context) {
        GoogleApiAvailability googleAPI = GoogleApiAvailability.getInstance();
        final int resultCode = googleAPI.isGooglePlayServicesAvailable(context);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                new Handler(context.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        GooglePlayServicesUtil.getErrorDialog(resultCode,
                                        (Activity) context, 100)
                                .show();
                    }
                });
            } else {
                Log.w(TAG,"GCMManager::checkPlayServices(): " + "This device is not supported.");
                // finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Get device push token
     *
     * @return Returns device push token
     */

    public void getToken(Activity context) {
        if (checkPlayServices(context)) {
            FirebaseMessaging.getInstance().getToken()
                    .addOnSuccessListener(token -> {
                        if (token != null && !token.isEmpty()) {
                            Log.i(TAG,"Retrieve push token successful: " + token);
                        } else {
                            Log.w(TAG,"token should not be null or empty...");
                        }
                        onTokenRefresh(token);
                    })
                    .addOnFailureListener(e -> Log.w(TAG,"Retrieve push token failed: " + e.getMessage()))
                    .addOnCanceledListener(() -> {
                        Log.w(TAG,"Retrieve push token canceled");
                    });
        } else {
            Log.i(TAG,"GCMManager::registerForCGM(): " + "No valid Google Play Services APK found.");
        }
    }

    /**
     *  Get locally saved inbox messages count
     *
     * @return Returns messages count saved locally
     */
    public int getInboxMessagesCount() {
        return ScgInboxDbHelper.getInstance(mContext).getMessagesCount();
    }

    /**
     *
     *  Get locally saved inbox message at given index
     *
     * @param index Message index to be fetched
     * @return Returns message at given index
     */
    public ScgMessage getInboxMessageAtIndex(int index) {
        return ScgInboxDbHelper.getInstance(mContext).getMessage(index);
    }

    /**
     * Get all locally saved inbox messages
     * @return Returns list of messages
     */
    public List<ScgMessage> getAllInboxMessages() {
        return ScgInboxDbHelper.getInstance(mContext).getAllMessages();
    }

    /**
     * Delete all locally saved messages from the inbox
     */
    public void deleteAllInboxMessages() {
        ScgInboxDbHelper.getInstance(mContext).deleteAllMessages();
    }

    /**
     *  Delete message from local inbox by message id
     *
     * @param messageId Message id to be deleted from the invox
     */
    public void deleteInboxMessage(String messageId) {
        ScgInboxDbHelper.getInstance(mContext).deleteMessage(messageId);
    }

    /**
     * Delete message frol local inbox by given index
     *
     * @param index Index of message to be deleted
     */
    public void deleteInboxMessageAtIndex(int index) {
        ScgInboxDbHelper.getInstance(mContext).deleteMessage(index);
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
                retrofit2.Response<ResponseBody> res = client.getService().downloadAttachment(strings[0], strings[1]).execute();

                if (res.code() == 503) {
                    int retryCount = 0;
                    long delay = ScgClient.getInstance().mInitialDelay;

                    do {
                        try {
                            Thread.sleep(delay);
                        } catch (InterruptedException e) {
                            Log.e(TAG, "doInBackground: ", e);
                        }
                        Log.d(TAG, "doInBackground: downloading " + strings[1] + " attachment of "
                                + strings[0] + ": 503 - retrying (" + retryCount + ")");
                        res = client.getService().downloadAttachment(strings[0], strings[1]).execute();
                        retryCount++;
                        delay *= 2;
                    } while (retryCount < ScgClient.getInstance().mRetryCount && res.code() == 503);
                }

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
