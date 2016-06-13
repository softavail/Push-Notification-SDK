package com.softavail.scg.push.demo;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.softavail.scg.push.sdk.ScgClient;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class MainActivity extends AppCompatActivity implements ScgClient.PushTokenListener, ScgClient.Result, ScgClient.PushNotificationListener {

    private static final String TAG = "MainActivity";
    private EditText accessToken;
    private TextView pushToken;

    final AuthService manager = AuthService.retrofit.create(AuthService.class);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        accessToken = (EditText) findViewById(R.id.access);
        pushToken = (TextView) findViewById(R.id.token);

        manager.listContacts().enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if (response.code() == 200) {
                    final List<String> tokens = new ArrayList<>();
                    try {
                        JSONArray raw = new JSONObject(response.body().string()).getJSONArray("list");
                        for (int i = 0; i < raw.length(); i++) {
                            JSONObject contact = raw.getJSONObject(i);
                            tokens.add(contact.getString("id"));
                        }

                        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
                        builder.setTitle("Obtain token for user id");
                        builder.setItems(tokens.toArray(new String[tokens.size()]), new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int item) {
                                dialog.dismiss();
                                final ProgressDialog waiting = ProgressDialog.show(MainActivity.this, "Access Token", "Getting access token...", true, false);
                                manager.generateAccessToken(tokens.get(item), new AuthService.GenerateRequest(1440)).enqueue(new Callback<ResponseBody>() {
                                    @Override
                                    public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                                        if (waiting != null && waiting.isShowing()) {
                                            waiting.dismiss();
                                        }
                                        if (response.code() == 200) {
                                            try {
                                                JSONObject data = new JSONObject(response.body().string());
                                                accessToken.setText(data.getString("id"));
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            } catch (IOException e) {
                                                e.printStackTrace();
                                            }
                                        } else {
                                            System.out.println(String.format("%s %s", response.code(), response.message()));
                                        }
                                    }

                                    @Override
                                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                                        if (waiting != null && waiting.isShowing()) {
                                            waiting.dismiss();
                                        }
                                    }
                                });
                            }
                        });
                        AlertDialog alert = builder.create();
                        alert.show();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    System.out.println(String.format("%s %s", response.code(), response.message()));
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.d(TAG, t.getMessage());
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        pushToken.setText(ScgClient.getInstance().getToken());

        ScgClient.getInstance().setNotificationListener(this);
        ScgClient.getInstance().setTokenListener(this);
    }

    public void onTokenRegister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            final String access = accessToken.getText().toString();
            if (!TextUtils.isEmpty(access)) {
                ScgClient.getInstance().auth(access);
                ScgClient.getInstance().registerPushToken(token, this);
            } else {
                Snackbar.make(view, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
            }

        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
        }
    }

    public void onTokenUnregister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            final String access = accessToken.getText().toString();
            if (!TextUtils.isEmpty(access)) {
                ScgClient.getInstance().auth(access);
                ScgClient.getInstance().unregisterPushToken(token, this);
            } else {
                Snackbar.make(view, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
            }
        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
        }
    }

    @Override
    public void onPushTokenRefreshed(final String token) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pushToken.setText(token);
                Snackbar.make(pushToken, "Push token refreshed", Snackbar.LENGTH_INDEFINITE).show();
            }
        });
    }

    @Override
    public void success(int code, String message) {
        Snackbar.make(pushToken, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
    }

    @Override
    public void failed(int code, String message) {
        Snackbar.make(pushToken, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
    }

    @Override
    public void onNotificationReceived(final String notificationId) {
        Snackbar.make(pushToken, String.format("Notification received: %s", notificationId), Snackbar.LENGTH_INDEFINITE)
                .setAction("Delivery confirmation", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ScgClient.getInstance().deliveryConfirmation(notificationId, MainActivity.this);
                    }
                })
                .show();
    }

    public void onGetToken(View view) {
        pushToken.setText(ScgClient.getInstance().getToken());
    }
}
