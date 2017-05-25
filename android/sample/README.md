SCG Push SDK
===

# Changelog
## 1.3.0
- added support for inbox and Badges
- added retry logic on some methods

## 1.2.0 (uses Firebase 9.8.0)
- added support for deep links and app data.
- added common method for confirmation of different events
- added handy ScgMessage class which wraps RemoteMessage
- update the ui and use the android binding framework
- update libraries
- fixed when and what to confirm in the sample

## 1.1.0 (uses Firebase 9.4.0)
- added attachments support
- added seen/interaction confirmation support

## 1.0.3
- initial version with delivery confirmation

# Pre-requirements
Configured project for the Android platform using Gradle and Android Studio

# SDK Download and Install
## Download

> TODO: way to distribute the SDK

## Install

> TODO: way to distribute the SDK

# Setup library
Before starting using the SCG Push SDK, library must be initialized.

Follow the instructions for initializing [Firebase Messaging Client](https://firebase.google.com/docs/cloud-messaging/android/client) on Android.

- Replace `.MyFirebaseMessagingService` service with  `com.syniverse.scg.push.sdk.ScgMessagingService`
- Replace `.MyFirebaseInstanceIDService` service with `com.syniverse.scg.push.sdk.ScgInstanceIdService`

```xml
<application .... >
  <service android:name="com.syniverse.scg.push.sdk.ScgMessagingService">
      <intent-filter>
          <action android:name="com.google.firebase.MESSAGING_EVENT" />
      </intent-filter>
  </service>
  <service android:name="com.syniverse.scg.push.sdk.ScgInstanceIdService">
      <intent-filter>
          <action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
      </intent-filter>
  </service>
  <receiver android:name=".MainReceiver"
            android:exported="false"
            android:enabled="true">
    <intent-filter>
        <action android:name="com.syniverse.scg.push.sdk.action.PUSH_TOKEN_RECEIVED"/>
        <action android:name="com.syniverse.scg.push.sdk.action.MESSAGE_RECEIVED"/>
    </intent-filter>
  </receiver>
</application>
```

## Register broadcast receiver
To handle receiving push notifications and refresh push tokens you must register in manifest or from some `Activity` an broadcast receiver. This receiver must extends `ScgPushReceiver`.

```xml
<receiver android:name=".MainReceiver" android:exported="false" android:enabled="true">
  <intent-filter>
      <action android:name="com.syniverse.scg.push.sdk.action.PUSH_TOKEN_RECEIVED"/>
      <action android:name="com.syniverse.scg.push.sdk.action.MESSAGE_RECEIVED"/>
  </intent-filter>
</receiver>
```
Make sure that the broadcast is not exported `android:exporeted="false"`

You must implement:

- `onPushTokenReceived(String token)`

  Called when device push token is registered for first time or refreshed.

- `onMessageReceived(String messageId, ScgMessage message)`

  Called when notification `message` with `messageId` arrived.

## Initialize with root URL and App ID
SDK Push library must be used as a singleton object. Before start using it,
you must initialize it with `rootUrl` and `appId`

You can initialize the library from every entry point, but `Application` class is preferred.

> Initialize in Applicaiton class:

```java
ScgClient.initialize(context, "http://api.example.com/v1","example.application.id");
```

After initialize instance of library can be obtain with:

```java
ScgClient client = ScgClient.getInstance();
```

Also you can check if library is initialized using `isInitiaized()` method:

```java
if (ScgClient.isInitiaized()) {
  // Library is initialized
  // Do further work
}
```

## Authentication

Before you can use SDK functionality (for example `register`/`unregister` push token or `delivery` report) you must authenticate using:

```java
ScgClient.getInstance().auth("validtoken");
```

# Register/Unregister push token

Device push token must registered before you can receive notifications. For both methods you must have properly initialized and authenticated library.

When device push token is refreshed or registered to the Firebase Messaging service you will
receive the it in the `onPushTokenReceived(String token)` method in the broadcast receiver you have registered.

## Register

To register given `token` you must call `registerPushToken` with `ScgCallback`:

```java
ScgClient.getInstance().registerPushToken(token, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When registration was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When registration failed
  }
});
```

**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*

## Unregister

To unregister given `token` you must call `unregisterPushToken` with `ScgCallback`:

```java
ScgClient.getInstance().unregisterPushToken(token, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When unregistration was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When unregistration failed
  }
});
```

**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*

# Handle notifications

Notifications are arrived using broadcast receiver whatever application is in background or foreground. You must decide what to do with the message - you can build and show notification to the system or use the message inside your application UI.

Registering two broadcasts one in the manifest and one in activity will deliver same notification twice. You can abort the broadcast using `abortBroadcast()` method after you consume the event from one of the broadcast receivers.

## Notification data
All notification data is located in the `ScgMessage` object, which provides handy methods to get data.

> Example checking if push message has attachment
```java
ScgMessage message....
message.hasAttachment();
```

## Handle notification attachment
Some notifications can have attachment ID, which can be used to against the SCG backend to query and download it.

Create new instance of `ScgClient.DownloadAttachment` and pass to `execute`:
- **messageId** - id of the message
- **attachmentId** - id of the attachment

```java
new ScgClient.DownloadAttachment(context) {
  @Override
  protected void onPreExecute() {
    // Update the UI, show progress for example
  }

  @Override
  protected void onResult(String mimeType, Uri result) {
      // Do what ever you want with the attachment file using the provided URI and mimeType.
  }

  @Override
  protected void onFailed(int code, String error) {
      // Update the UI, show error for example
  }
}.execute(messageId, message.getAttachment());
```

Note that attachments are downloaded in the files directory of the application. If you want to give access to other application you must provide `URI_READ_PERMISSIONS` or `URI_WRITE_PERMISSIONS` for this URI and the target application in the intent.

If your logic heavily download attachments, consider saving the `ScgClient.DownloadAttachment` object. You can call `execute` multiple times with different `messageId` and `attachmentId`.

## Handle deep links and app data
Some notifications can contains also deep link or app data. You can check and query them using provided in `ScgMessage` methods.

> Example of checking for deep link or add data

```java
boolean hasDeepLink = scgMsg.hasDeepLink();
boolean hasAppData = scgMsg.hasAppData();
```

### Resolve tracked URL
Some deep links are tracked, this means that you must resolve them to get the real URL. SCG SDK provides easy way to do this:

> Example of resolving tracked URL

```java
if (message.hasDeepLink()) {
    ScgClient.getInstance().resolveTrackedLink(message.getDeepLink(), new ScgCallback() {
        @Override
        public void onSuccess(int code, String resolvedUrl) {
            ...
            Update notification/UI etc.
        }

        @Override
        public void onFailed(int code, String errorMessage) {
        }
    });
}

```


# Delivery and seen/interaction report

Once message is arrived you can perform **optionally** , confirmation report by calling ` ScgClient.getInstance().confirm(messageId, ScgState.DELIVERED, callback);` with the `messageId`, `ScgState` and some `callback`:

```java
ScgClient.getInstance().confirm(messageId, messageState, new ScgCallback() {
  @Override
  public void onSuccess(int code, String message) {
      // When delivery was successful
  }

  @Override
  public void onFailed(int code, String message) {
    // When delivery report failed
  }
});
```

## Supported event confirmations

- `ScgState.DELIVERED` - message is delivered to the device, but cannot say if is open
- `ScgState.MEDIA_REQUESTED`
- `ScgState.READ`
- `ScgState.CLICKTHRU` - after we download attachment or follow deep link
- `ScgState.CONVERTED`


**Note that:** when failed `code` will be one of the valid http error codes and `message`
will give you some human error message.

*Example: 401 will be returned if you are not authenticated in front of service.*

# Manage the inbox

You can manage your inbox which represent locally saved messages by the `ScgClient` methods:

* `resetBadgesCounter()` - which clear the badge counter and mark all massages as read.
* `deleteAllInboxMessages()`
* `deleteInboxMessage()` - which delete message with given id
* `deleteInboxMessageAtIndex()` - which delete message on given index
* `getAllInboxMessages()`
* `getInboxMessageAtIndex()`
* `getInboxMessagesCount()`
