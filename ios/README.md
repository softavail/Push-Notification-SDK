SCG Push SDK
===

# Pre-requirements
Configured project used Xcode

# SDK Download and Install
## Download

> TODO: way to distribute the SDK

## Install

> TODO: way to distribute the SDK
Drag the SCGPush.framework file to the project in Xcode

Than:

> Import library

> Swift
```swift
import SSCGPush
```

For Objective-C project
1. Under Build Settings, in Packaging, make sure the Defines Module setting for that framework target is set to “Yes".

2. Import library
> Objective-C
```objective-c
#import <SCGPush/SCGPush-Swift.h>
```


## Initialize with root URL and App ID
SDK Push library must be used as a singleton object. Before start using it,
you must initialize it with `callbackURI` and `appID`

You can initialize the library from every entry point, but `AppDelegate` class is preferred.

> Initialize in AppDelegate class:

> Swift
```swift
SSCGPush.instance.appID = "your app id"
SCGPush.instance.callbackURI = "http://example.com"
```

> Objective-C
```objective-c
[[SSCGPush instance] setAppID:@"your app id"];
[[SSCGPush instance] setCallbackURI:@"http://example.com"];
```

## Authentication

Before you can use SDK functionality (for example `register`/`unregister` push token or `delivery` report) you must authenticate using:

> Set authentication token

> Swift
```swift
SCGPush.instance.accessToken = "your access token"
```

> Objective-C
```objective-c
[[SCGPush instance] setAccessToken:@"your access token"];
```

# Register/Unregister push token

Device push token must registered before you can receive notifications. For both methods you must have properly initialized and authenticated library.

## Register

To register given `token` you must call `registerPushToken`:

> Swift
```swift
SCGPush.instance.registerPushToken("your device token",
            completionBlock: {
                //handle when successful register the push token
            }) { (error) in
                //handle when some error occurred
                //use error.description for more details
        }
```

> Objective-C
```objective-c
[[SCGPush instance] registerPushToken:@"your device token"
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
    SCGPush.instance.registerPushToken(deviceTokeData: deviceToken, completionBlock: {
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
  [[SCGPush instance] registerPushTokenWithDeviceTokeData:deviceToken
                          completionBlock:^{
                              //handle when successful register the push token
                          } failureBlock:^(NSError * error) {
                              //handle when some error occurred
                              //use error.description for more details
                          }];
  ...
}
```

If you want to register `token` somewhere else, you can save token with `saveDeviceToken` method.

> Swift
```swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    ...
    SCGPush.instance.saveDeviceToken(deviceTokenData: deviceToken)
    ...
}
```

> Objective-C
```objective-c
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  ...
  [[SCGPush instance] saveDeviceTokenWithDeviceTokenData:deviceToken];
  ...
}
```

And call `registerPushToken(completionBlock, failureBlock: failureBlock)`:

> Swift
```swift
SCGPush.instance.registerPushToken(completionBlock: {
            //handle when successful register the push
           }) { (error) in
            //handle when some error occurred
            //use error.description for more details
       }
```

> Objective-C
```objective-c
[[SCGPush instance] registerPushToken:^{
        //handle when successful register the push token
    } failureBlock:^(NSError * error) {
        //handle when some error occurred
        //use error.description for more details
    }];
```

## Unregister

To unregister given `token` you must call `unregisterPushToken`:

> Swift
```swift
SCGPush.instance.unregisterPushToken({
            //handle when successful register the push
            }) { (error) in
            //handle when some error occurred
            //use error.description for more details
        }
```

> Objective-C
```objective-c
[[SCGPush instance] unregisterPushToken:^{
        //handle when successful register the push token
    } failureBlock:^(NSError * error) {
        //handle when some error occurred
        //use error.description for more details
    }];
```


# Delivery report

Once message is arrived you can perform optionally delivery report by calling ` deliveryConfirmation`:

> Swift
```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
       ...
       SCGPush.instance.deliveryConfirmation(userInfo: userInfo, completionBlock: {
             //handle when successful register the push
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
  [[SCGPush instance] deliveryConfirmationWithUserInfo:userInfo
  completionBlock:^{
        //handle when successful register the push token
    } failureBlock:^(NSError * error) {
        //handle when some error occurred
        //use error.description for more details
    }
  ...
}
```
