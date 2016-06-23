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
//        ScgClient.initialize(this, "http://95.158.130.102:8080/scg-dra/proxy/", "343875524685");
    }
}
