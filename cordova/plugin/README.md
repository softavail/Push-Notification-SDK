SCG Push SDK - Cordova
===

This is the SCG Push SDK for Cordova. It is distributed as a plugin. The platforms supported are Android and iOS.

# SDK Usage

## Install

Add the plugin to your project:

```
cordova plugin add @syniverse/cordova-plugin-scg-push
```

## Initialize

Call the `start` method of the plugin to initialize it:

```
scg.push.start(accessToken, appId, callbackUri, function() {
    console.log('ok start');
}, function(error) {
    console.error('error start ' + error);
});
```

The parameters are:
Param  | Description
-- | --
accessToken  |
appId  |
callbackUri  | The URL of the SCG REST service
success | The callback function for the successful operation
failure | The callback function for the failed operation

## Register Push token

To register the push token call:

```
scg.push.registerPushToken(pushToken, function(result) {
    console.log('ok registerPushToken ');
}, function(error) {
    console.error('error registerPushToken: ' + error);
});
```
