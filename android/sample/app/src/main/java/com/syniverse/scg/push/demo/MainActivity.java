package com.syniverse.scg.push.demo;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TabLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SwitchCompat;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;
import com.syniverse.scg.push.sdk.ScgCallback;
import com.syniverse.scg.push.sdk.ScgClient;
import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgPushReceiver;
import com.syniverse.scg.push.sdk.ScgState;

import java.util.ArrayList;
import java.util.List;

import io.fabric.sdk.android.Fabric;
import me.leolin.shortcutbadger.ShortcutBadger;


public class MainActivity extends AppCompatActivity implements ScgCallback {

    private static final String TAG = "MainActivity";

    private static final String PREF_URL = "PREF_URL";
    private static final String PREF_APP_ID = "PREF_APP_ID";
    private static final String PREF_AUTH = "PREF_TOKEN";
    public static final String PREF_BADGE_COUNT = "PREF_BADGE_COUNT";

    public static final String PREF_AUTO_DELIVERY = "PREF_AUTO_DELIVERY";
    public static final String PREF_AUTO_OPEN = "PREF_AUTO_OPEN";

    private EditText accessToken;
    private TextView pushToken;
    private MessageAdapter adapter;
    private TabLayout messagesTabs;
    private MenuItem menuResetBadge;

    private List<ScgMessage> pushMessages = new ArrayList<>();

    protected SharedPreferences pref;

    private final ScgPushReceiver receiver = new ScgPushReceiver() {
        @Override
        protected void onPushTokenReceived(final String token) {

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    pushToken.setText(token);
                    Snackbar.make(pushToken, "Push token refreshed", Snackbar.LENGTH_LONG).show();
                }
            });

            abortBroadcast(); // Block passing the broadcast to the receiver in the manifest
        }

        @Override
        protected void onMessageReceived(String messageId, ScgMessage message) {
            handleMessageReceive(messageId, message);
            abortBroadcast(); // Block passing the broadcast to the receiver in the manifest
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        adapter = new MessageAdapter(this);

        messagesTabs = (TabLayout) findViewById(R.id.tabsMessages);
        initSelectedTab();
        messagesTabs.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                initSelectedTab();
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        accessToken = (EditText) findViewById(R.id.access);
        pushToken = (TextView) findViewById(R.id.token);

        RecyclerView messages = (RecyclerView) findViewById(R.id.messages);
        messages.setLayoutManager(new LinearLayoutManager(this));
        messages.setAdapter(adapter);

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

        onNewIntent(getIntent());
    }

    private void initSelectedTab() {
        if (messagesTabs.getSelectedTabPosition() == 0) {
            adapter.setMessgaes(pushMessages, false);
        } else {
            adapter.setMessgaes(ScgClient.getInstance().getAllInboxMessages(), true);
        }
    }

    private void initBadgeCount() {
        int badge = pref.getInt(PREF_BADGE_COUNT, -1);

        if (badge > 0) {
            ShortcutBadger.applyCount(this, badge);
        } else {
            ShortcutBadger.removeCount(this);
        }
        setBadgeCountMenuItem(badge);
    }

    private void setBadgeCountMenuItem(int count) {
        if (menuResetBadge != null) {
            menuResetBadge.setVisible(count > 0);
            menuResetBadge.setEnabled(count > 0);
        }
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        menuResetBadge = menu.add(R.string.menu_reset_badges_count);
        if (pref == null || pref.getInt(PREF_BADGE_COUNT, -1) <= 0) {
            menuResetBadge.setVisible(false);
            menuResetBadge.setEnabled(false);
        }

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item == menuResetBadge) {
            onResetBadgesCount(item.getActionView());
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void onResetBadgesCount(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            ScgClient.getInstance().resetBadgesCounter(token, new ScgCallback() {
                @Override
                public void onSuccess(int code, String message) {
                    if (code >= 200 && code < 300) {
                        resetBadgeCount();
                    }

                    MainActivity.this.onSuccess(code, message);
                }

                @Override
                public void onFailed(int code, String message) {
                    MainActivity.this.onFailed(code, message);
                }
            });
        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_LONG).show();
        }
    }

    private void resetBadgeCount() {
        pref.edit().putInt(PREF_BADGE_COUNT, 0).apply();
        ShortcutBadger.removeCount(this);
        setBadgeCountMenuItem(0);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);

        if (getIntent().hasExtra(MainReceiver.MESSAGE_ID))
            handleMessageReceive(getIntent().getStringExtra(MainReceiver.MESSAGE_ID), (ScgMessage) getIntent().getParcelableExtra(MainReceiver.MESSAGE));

    }

    @Override
    protected void onStart() {
        super.onStart();
        final IntentFilter filter = new IntentFilter(ScgPushReceiver.ACTION_MESSAGE_RECEIVED);
        filter.addAction(ScgPushReceiver.ACTION_PUSH_TOKEN_RECEIVED);
        filter.setPriority(1);
        registerReceiver(receiver, filter);

        initBadgeCount();
    }

    @Override
    protected void onStop() {
        super.onStop();
        unregisterReceiver(receiver);
    }

    private void showDialog() {
        final View initView = LayoutInflater.from(this).inflate(R.layout.dialog_initialization, null, false);
        ((SwitchCompat) initView.findViewById(R.id.delivery)).setChecked(pref.getBoolean(PREF_AUTO_DELIVERY, true));
        ((SwitchCompat) initView.findViewById(R.id.open)).setChecked(pref.getBoolean(PREF_AUTO_OPEN, true));
        ((EditText) initView.findViewById(R.id.apiUrl)).setText(pref.getString(PREF_URL, getString(R.string.rootUrl)));
        ((EditText) initView.findViewById(R.id.appId)).setText(pref.getString(PREF_APP_ID, getString(R.string.appId)));

        final AlertDialog.Builder init = new AlertDialog.Builder(this);
        init.setTitle("Setup SCG library")
                .setView(initView)
                .setPositiveButton("Finish", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.cancel();
                    }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                final String uri = ((EditText) initView.findViewById(R.id.apiUrl)).getText().toString();
                final String appid = ((EditText) initView.findViewById(R.id.appId)).getText().toString();
                final boolean autoDelivery = ((SwitchCompat) initView.findViewById(R.id.delivery)).isChecked();
                final boolean autoOpen = ((SwitchCompat) initView.findViewById(R.id.open)).isChecked();

                if (TextUtils.isEmpty(uri) || TextUtils.isEmpty(appid)) {
                    Toast.makeText(MainActivity.this, "Library must be initialised properly!", Toast.LENGTH_LONG).show();
                    finish();
                    return;
                }

                pref.edit()
                        .putString(PREF_URL, uri)
                        .putString(PREF_APP_ID, appid)
                        .putBoolean(PREF_AUTO_DELIVERY, autoDelivery)
                        .putBoolean(PREF_AUTO_OPEN, autoOpen)
                        .apply();

                if (ScgClient.isInitialized()) {
                    recreate();
                } else {
                    init(uri, appid, pref.getString(PREF_AUTH, null));
                }
            }
        }).show();
    }

    private void init(String url, String appId, String auth) {
        if (ScgClient.isInitialized()) {
            ScgClient.destroyInstance();
        }

        ScgClient.initialize(MainActivity.this, url, appId, 5, 200);
        ScgClient.getInstance().auth(auth);
        pushToken.setText(ScgClient.getInstance().getToken());
        accessToken.setText(auth);
    }


    public void onTokenRegister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            ScgClient.getInstance().registerPushToken(token, this);
        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_LONG).show();
        }
    }

    public void onTokenUnregister(final View view) {
        final String token = pushToken.getText().toString();

        if (!TextUtils.isEmpty(token)) {
            ScgClient.getInstance().unregisterPushToken(token, this);
        } else {
            Snackbar.make(view, "Push token is null or invalid", Snackbar.LENGTH_LONG).show();
        }
    }

    private void reportState(String messageId, ScgState state) {
        ScgClient.getInstance().confirm(messageId, state, MainActivity.this);
    }

    @Override
    public void onSuccess(int code, String message) {
        Snackbar.make(pushToken, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_LONG).show();
    }

    @Override
    public void onFailed(int code, String message) {
        Snackbar.make(pushToken, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_LONG).show();
    }

    private void handleMessageReceive(final String messageId, ScgMessage message) {
        int badgeCount = message.getBadge();
        if (badgeCount >= 0) {
            setBadgeCountMenuItem(badgeCount);
        }

        if (pref.getBoolean(PREF_AUTO_DELIVERY, true)) {
            reportState(messageId, ScgState.DELIVERED);
        }

        if (pref.getBoolean(PREF_AUTO_OPEN, true)) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    reportState(messageId, ScgState.CLICKTHRU);
                }
            }, 3141);
        }

        if (!message.isInbox()) {
            pushMessages.add(message);
            //if push messages selected
            if (messagesTabs.getSelectedTabPosition() == 0) {
                adapter.addMessage(message);
            }
        } else if (messagesTabs.getSelectedTabPosition() == 1) {
            adapter.addMessage(message);
        }
    }

    public void saveAccessToken(View view) {
        if (TextUtils.isEmpty(accessToken.getText().toString())) return;

        if (ScgClient.isInitialized()) {
            pref.edit().putString(PREF_AUTH, accessToken.getText().toString()).commit();
            ScgClient.getInstance().auth(accessToken.getText().toString());
            Snackbar.make(pushToken, "Saved", Snackbar.LENGTH_SHORT).show();
        }
    }
}
