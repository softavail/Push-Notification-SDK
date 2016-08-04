package com.softavail.scg.push.sdk;

/**
 * Created by lekov on 6/15/16.
 */
public interface ScgCallback {
    /**
     * @param code
     * @param message
     */
    void onSuccess(int code, String message);

    /**
     * @param code
     * @param message
     */
    void onFailed(int code, String message);
}
