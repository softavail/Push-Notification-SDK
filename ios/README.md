
SCG Push SDK
===

# Pre-requirements
Configure your project to use Xcode.

# SDK Installation



## Install


Drag the SCGPushSDK.framework file to the project in Xcode.

Then:

> Import library
> Swift
```swift
import SSCGPushSDK
```

> Objective-C
```objective-c
import <SCGPushSDK/SCGPush.h>
```

## Initialize with root URL and App ID
The SDK Push library must be used as a singleton object. Before start using it,
you must initialize it with `accessToken`, `callbackURI` and `appID`.

You can initialize the library from every entry point, but `AppDelegate` class is preferred.

> Initialize in AppDelegate class:

> Swift
```swift
SCGPush.start(withAccessToken: "YOUR_ACCESS_TOKEN", appId: "YOUR_APP_ID", callbackUri: "http://example.com", delegate: nil)
```

> Objective-C
```objective-c
[SCGPush startWithAccessToken: @"YOUR_ACCESS_TOKEN" 
                        appId: @"YOUR_APP_ID"
                  callbackUri: @"http://example.com"
                     delegate: nil]
```

# Register/Unregister push token

Device push token must registered before you can receive notifications. For both methods you must have properly initialized and authenticated library.

## Register

To register given `token` you must call `registerPushToken`:

> Swift
```swift
SCGPush.sharedInstance().registerToken("your device token",
            completionBlock: {
                //handle when successful register the push token
            }) { (error) in
                //handle when some error occurred
                //use error.description for more details
        }
```

> Objective-C
```objective-c
[[SCGPush sharedInstance] registerToken:@"your device token"
                          completionBlock:^{
                              //handle when successful register the push token
                          } failureBlock:^(NSError * error) {
                              //handle when some error occurred
                              //use error.description for more details
                          }];
```

You can register token in `didRegisterForRemoteNotificationsWithDeviceToken` method in `AppDelegate` class.

*For example:*

> Swift
```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    ...
    SCGPush.sharedInstance().registerToken(deviceTokeData: deviceToken, completionBlock: {
            //handle when successful register the push token
        }) { (error) in
            //handle when some error occurred
            //use error.description for more details
    }
    ...
}
```

If you are working on Objective-C project You can register token in `- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken` method in `AppDelegate.m` class.

> Objective-C
```objective-c
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  ...
  [[SCGPush sharedInstance] registerTokenWithDeviceTokeData:deviceToken
                          completionBlock:^{
                              //handle when successful register the push token
                          } failureBlock:^(NSError * error) {
                              //handle when some error occurred
                              //use error.description for more details
                          }];
  ...
}
```

## Unregister

To unregister given `token` you must call `unregisterPushToken`:

> Swift
```swift
SCGPush.sharedInstance().unregisterPushToken({
            //handle when successful register the push
            }) { (error) in
            //handle when some error occurred
            //use error.description for more details
        }
```

> Objective-C
```objective-c
[[SCGPush sharedInstance] unregisterPushToken:^{
        //handle when successful register the push token
    } failureBlock:^(NSError * error) {
        //handle when some error occurred
        //use error.description for more details
    }];
```


# Report status

If you want to update the status of a recieved push message with the SCG server you can use `reportStatus`.
Allowed statuses are:
  - DELIVERED
  - MEDIA REQUESTED
  - READ
  - CLICKTHRU
  - CONVERTED


> Swift
```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
       ...
       SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.delivered, completionBlock: {
             //send report when the message is read
             }) { (error) in
             //handle when some error occurred
             //use error.description for more details
        }
        ...
}
```

> Objective-C
```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  ...
  [[SCGPush sharedInstance] reportStatusWithMessageId:messageID andMessageState:MessageStateDelivered
  completionBlock:^{
        //handle when successful register the push token
    } failureBlock:^(NSError * error) {
        //handle when some error occurred
        //use error.description for more details
    }
  ...
}
```

# Resolve Tracked Link

If you want to send an URL via push messages, you have to use `resolveTrackedLink` to track the correct URL.
For that you have to register for `SessionDelegateHandler`

> Swift
```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
       ...
       SCGPush.shared.resolveTrackedLink(url)
        ...
}

func resolveTrackedLinkDidSuccess(redirectLocation: String, request: URLRequest) {
       Take the result of the original url - redirectLocation
}
```

*For example:*
> Swift
```swift
...
class YourClass:TypeOfClass, SCGPushDelegate{
...
func init(){
       SCGPush.shared.delegate = self
}
...
```

# Push notification with media content

This feature is new for iOS and it is supported in iOS 10 and later
With this functionality you can present an image, an animated image, a video or audio on notification screen.

1. Create an `App Group`
  1.1 Go to apple developer portal
  1.2 Go to `Certificates, Identifiers & Profiles`
  1.3 Under the `Indentifiers` tab select `App Groups`
  1.4 Enter a description and identifier (`group.` will be automatically added in front after you created the identifier)
  1.5 Go to `App IDs` under the `Indentifiers` tab
  1.6 Select your app, activate `App Groups` under `Application Services` and select the group you just created

2. Create `Notification Service Extension`
  2.1 Open your project
  2.2 Select File->New->Target...
  2.3 Choose `Notification Service Extension`. Write a product name (e.x. `NotificationService`)
  2.4 A new Group will be added to your project with same name. Open it and select YourProductName.swift (e.x. `NotificationService.swift`) or YourProductName.m for Objective-c (e.x. `NotificationService.m`)

3. Load the attachment from push message and present it
  3.1 In function `didReceive withContentHandler` pass SCGPush your group identifier that was created in step 1.
  > Swift
  ```swift
        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

            SCGPush.shared.groupBundle = "your.group.bundel.identifier"
            ...
  ```

  3.2 Load the attachment with `loadAttachment`
  > Swift
  ```swift
        SCGPush.shared.loadAttachment(messageID, attachmentID: attachmentID, completionBlock: {
                (url, type) in
                let options = [UNNotificationAttachmentOptionsTypeHintKey: type]
                if let attachment = try? UNNotificationAttachment(identifier: "someID", url: url, options: options) {
                    self.bestAttemptContent?.attachments = [attachment]
                }
                self.contentHandler!(self.bestAttemptContent!)
            }, failureBlock: { (error) in
                print("load error", error!)
            })
  ```

4. Set the group identifier in the SDK.
  *IMPORTANT*
  You must declare `groupBundle` before `appID` and `callbackURI`
> Swift
```swift
    SCGPush.shared.groupBundle = "your.group.bundel.identifier"
    SCGPush.instance.appID = "your app id"
    SCGPush.instance.callbackURI = "http://example.com"
```

# Push inbox

You can manage your inbox which represent locally saved messages by the `SCGPush` methods:
1. Push message to inbox
> Swift
```swift
    open func push(toInbox payload: [AnyHashable : Any]) -> Bool
```

2. Get number of inbox messages
> Swift
```swift
    open func numberOfMessages() -> UInt
```

3. Get message at specified index
> Swift
```swift
    open func message(at index: UInt) -> SCGPushMessage?
```

4. Delete inbox message
> Swift
```swift
    open func delete(_ message: SCGPushMessage) -> Bool
```

5. Delete inbox message by index
> Swift
```swift
    open func deleteMessage(at index: UInt) -> Bool
```

6. Delete all inbox messages
> Swift
```swift
    open func deleteAllMessages() -> Bool
```

7. Load attachment for inbox message ( 
> Swift
```swift
    open func loadAttachment(for message: SCGPushMessage, completionBlock: ((SCGPushAttachment) -> Swift.Void)?, failureBlock: ((Error?) -> Swift.Void)? = nil)
```

8. Get attachment for inbox message
> Swift
```swift
    open func getAttachmentFor(_ message: SCGPushMessage) -> SCGPushAttachment?
```
