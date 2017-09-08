SCG Push SDK - Cordova
===

This is the SCG Push SDK for Cordova. It is distributed as a plugin. The platforms supported are Android and iOS.

# SDK Usage

## Install

Add the plugin to your project:

```
cordova plugin add @syniverse/cordova-plugin-scg-push
```

Download your Firebase configuration file for Android (google-services.json) and place it in the root folder of your cordova application.

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
accessToken  | Access token to authenticate
appId  | Application Id
callbackUri  | The URL of the SCG REST service
success | The callback function for the successful operation
failure | The callback function for the failed operation

## Get the Push Token (Android only)

To get the application specific push token:

```
scg.push.getToken(function(token) {
    // use the token to register it
    console.log('ok getToken ' + token);
},  function(error) {
    console.error('error getToken ' + error);
});
```
**Note**: for iOS this method will return an empty string (`''`).

## Register Push token

To register the push token call:

```
scg.push.registerPushToken(pushToken, function(result) {
    console.log('ok registerPushToken ');
}, function(error) {
    console.error('error registerPushToken: ' + error);
});
```

## Unregister Push token
To stop receiving SCG messages call unregisterPushToken :

```
scg.push.unregisterPushToken(pushToken, function(result) {
    console.log('ok unregisterPushToken ');
}, function(error) {
    console.error('error unregisterPushToken: ' + error);
});
```

## Register callback to receive SCG messages (Android Only)
```
scg.push.onNotification(function(scgMessage) {
    console.log('ok onNotification ' + JSON.stringify(data));
}, function (error) {});
```

### Receiving a notification flow:
  - The application is in foreground: the notification (the SCG message) is received in the callback
  - The application is in background:
    - The message notification type is **os** ("push:notify_type":"os"): after the user click on the notification and the application registers the callback for the messages, the callback will be called with the message data;
    - The message notification type is **silent** or **app**: after the application registers the callback it will receive the message (the callback will be called) .

## Register callback for the token changes (Android only)
To register for Firebase token change notifications:
```
scg.push.onTokenRefresh(function(newToken) {
    console.log('ok onNewToken ' + newToken);
}, function() {});
```

## Report message status
```
scg.push.reportStatus(messageId, messageState, function(data) {
    console.log('ok reportStatus ' + JSON.stringify(data));
}, function (error) {
    console.log('error reportStatus ' + JSON.stringify(error));
});
```

Where `messageId` is the id of the message.
And `messageState` can one of the following:
 - DELIVERED,
 - MEDIA_REQUESTED,
 - READ,
 - CLICKTHRU,
 - CONVERTED.

##  Resolve tracked link
```
scg.push.resolveTrackedLink(message['deep_link'], function(data) {
    console.log('ok resolveTrackedLink ' + JSON.stringify(data));
}, function (error) {
    console.log('error resolveTrackedLink ' + JSON.stringify(error));
});
```

## Download a message attachment
If the message contains an attachment it can be download:
```
scg.push.loadAttachment(message['scg-message-id'], message['scg-attachment-id'], function(data) {
    console.log('ok loadAttachment ' + JSON.stringify(data));
}, function (error) {
    console.log('error loadAttachment ' + JSON.stringify(error));
});
```

The `data` in the success callback contains the mimeType of the attachment and local URI of the downloaded file.

## Reset badge count
```
scg.push.resetBadge(pushToken, function(data) {
    console.log('ok resetBadge ' + JSON.stringify(data));
}, function (error) {
    console.log('error resetBadge ' + JSON.stringify(error));
});
```

Where `pushToken` is the registered token.

## Delete all inbox messages
All messages stored in the inbox can be deleted:

```
scg.push.deleteAllInboxMessages();
```

## Delete an inbox message by message id
```
scg.push.deleteInboxMessage(message['scg-message-id']);
```

## Delete an inbox message by index

```
scg.push.deleteInboxMessageAtIndex(0);

```

## Get all inbox messages
```
scg.push.getAllInboxMessages(function(data) {
    console.log('ok getAllInboxMessages ' + JSON.stringify(data));
});
```

## Get inbox message at index

```
scg.push.getInboxMessageAtIndex(0, function(message) {
    console.log('ok getInboxMessageAtIndex ' + JSON.stringify(message));
}, function (error) {
    console.log('error getInboxMessageAtIndex ');
});
```

## Get inbox messages count

```
scg.push.getInboxMessagesCount(function(count) {
    console.log('ok getInboxMessagesCount ' + count);
});
```
