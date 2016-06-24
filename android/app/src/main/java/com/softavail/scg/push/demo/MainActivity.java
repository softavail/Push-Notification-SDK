package com.softavail.scg.push.demo;

import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.SwitchCompat;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.messaging.RemoteMessage;
import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;
import com.softavail.scg.push.sdk.ScgListener;


public class MainActivity extends AppCompatActivity implements ScgListener, ScgCallback {

    private static final String TAG = "MainActivity";

    private static final String PREF_URL = "PREF_URL";
    private static final String PREF_APP_ID = "PREF_APP_ID";
    private static final String PREF_AUTO_DELIVERY = "PREF_AUTO_DELIVERY";
    private static final String PREF_AUTH = "PREF_TOKEN";

    private EditText accessToken;
    private TextView pushToken;
    private View authPanel;

    protected SharedPreferences pref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        accessToken = (EditText) findViewById(R.id.access);
        pushToken = (TextView) findViewById(R.id.token);
        authPanel = findViewById(R.id.authpanel);

        View setup = findViewById(R.id.fab);
        setup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showDialog();
            }
        });

        pref = PreferenceManager.getDefaultSharedPreferences(this);
        String url = pref.getString(PREF_URL, null);
        String appId = pref.getString(PREF_APP_ID, null);
        String auth = pref.getString(PREF_AUTH, null);

        if (url == null || appId == null) {
            showDialog();
        } else {
            init(url, appId, auth);
        }

        if (getIntent().hasExtra("scg-message-id"))
            onMessageReceived(getIntent().getStringExtra("scg-message-id"), null);
    }

    private void showDialog() {
        final View initView = LayoutInflater.from(this).inflate(R.layout.dialog_initialization, null, false);
        ((SwitchCompat) initView.findViewById(R.id.delivery)).setChecked(pref.getBoolean(PREF_AUTO_DELIVERY, true));

        final AlertDialog.Builder init = new AlertDialog.Builder(this);
        init.setTitle("Setup SCG library")
                .setView(initView)
                .setPositiveButton("Finish", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        final String uri = ((EditText) initView.findViewById(R.id.apiUrl)).getText().toString();
                        final String appid = ((EditText) initView.findViewById(R.id.appId)).getText().toString();
                        final boolean autoDelivery = ((SwitchCompat) initView.findViewById(R.id.delivery)).isChecked();

                        if (TextUtils.isEmpty(uri) || TextUtils.isEmpty(appid)) {
                            Toast.makeText(MainActivity.this, "Library must be initialised properly!", Toast.LENGTH_LONG).show();
                            finish();
                            return;
                        }

                        pref.edit()
                                .putString(PREF_URL, uri)
                                .putString(PREF_APP_ID, appid)
                                .putBoolean(PREF_AUTO_DELIVERY, autoDelivery)
                                .commit();

                        if (ScgClient.isInitialized()) {
                            recreate();
                        } else {
                            init(uri, appid, null);
                        }
                    }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                Toast.makeText(MainActivity.this, "Library must be initialised!", Toast.LENGTH_LONG).show();
                finish();
            }
        }).show();
    }

    private void init(String url, String appId, String auth) {
        ScgClient.initialize(MainActivity.this, url, appId);
        ScgClient.getInstance().setListener(MainActivity.this);
        pushToken.setText(ScgClient.getInstance().getToken());

        if (auth != null) {
            authPanel.setVisibility(View.GONE);
            ScgClient.getInstance().auth(auth);
        } else {
            authPanel.setVisibility(View.VISIBLE);
        }
    }


    public void onTokenRegister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            final String access = pref.getString(PREF_AUTH, null);
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
            final String access = pref.getString(PREF_AUTH, null);
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

    private void reportDelivery(String messageId) {
        final String access = pref.getString(PREF_AUTH, null);
        if (!TextUtils.isEmpty(access)) {
            ScgClient.getInstance().auth(access);
            ScgClient.getInstance().deliveryConfirmation(messageId, MainActivity.this);
        } else {
            Snackbar.make(pushToken, "Access token is null or invalid", Snackbar.LENGTH_INDEFINITE).show();
        }
    }

    @Override
    public void onSuccess(int code, String message) {
        Snackbar.make(pushToken, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
    }

    @Override
    public void onFailed(int code, String message) {
        Snackbar.make(pushToken, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();

        if (code == 401) {
            pref.edit().remove(PREF_URL).commit();
            authPanel.setVisibility(View.VISIBLE);
            accessToken.getText().clear();
        }
    }

    @Override
    public void onPushTokenReceived(final String token) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pushToken.setText(token);
                Snackbar.make(pushToken, "Push token refreshed", Snackbar.LENGTH_INDEFINITE).show();
            }
        });
    }

    @Override
    public void onMessageReceived(final String messageId, RemoteMessage message) {

        if (pref.getBoolean(PREF_AUTO_DELIVERY, true)) {
            reportDelivery(messageId);
        } else {

            Snackbar.make(pushToken, String.format("Notification received: %s", messageId), Snackbar.LENGTH_INDEFINITE)
                    .setAction("Delivery confirmation", new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            reportDelivery(messageId);
                        }

                    })
                    .show();
        }
    }

    @Override
    public void onPlayServiceError() {

    }

    public void saveAccessToken(View view) {
        if (TextUtils.isEmpty(accessToken.getText().toString())) return;

        if (ScgClient.isInitialized()) {
            pref.edit().putString(PREF_AUTH, accessToken.getText().toString()).commit();
            ScgClient.getInstance().auth(accessToken.getText().toString());
            authPanel.setVisibility(View.GONE);
        }
    }
}
