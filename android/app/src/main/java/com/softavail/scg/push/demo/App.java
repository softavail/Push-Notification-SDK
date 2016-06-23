package com.softavail.scg.push.demo;

import android.app.Application;

import com.softavail.scg.push.sdk.ScgClient;

/**
 * Created by lekov on 6/12/16.
 */
public class App extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        ScgClient.initialize(this, getString(R.string.rootUrl), getString(R.string.appId));
    }
}
