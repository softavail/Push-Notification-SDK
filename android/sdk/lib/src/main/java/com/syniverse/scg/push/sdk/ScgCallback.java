package com.syniverse.scg.push.sdk;

/**
 * Created by lekov on 6/15/16.
 */
public interface ScgCallback {
    /**
     * On operation success
     *
     * @param code in most cases HTTP code
     * @param message error message
     */
    void onSuccess(int code, String message);

    /**
     * On operation failed
     *
     * @param code error code, in most cases HTTP code
     * @param message error message
     */
    void onFailed(int code, String message);
}
