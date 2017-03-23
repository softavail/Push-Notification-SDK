//
//  AppDelegate.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit
import SCGPushSDK
import UserNotifications

#if WITH_CRASHLYTICS
    import Fabric
    import Crashlytics
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if WITH_CRASHLYTICS
            debugPrint("WITH_CRASHLYTICS")
            Fabric.with([Crashlytics.self])
        #else
            debugPrint("NO CRASHLYTICS")
        #endif

        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        let savedToken:String? = UserDefaults.standard.string(forKey: "token")
        let savedAppid:String? = UserDefaults.standard.string(forKey: "appid")
        let savedBaseurl:String? = UserDefaults.standard.string(forKey: "baseurl")

        let token: String = savedToken != nil ? savedToken! : ""
        let appid: String = savedAppid != nil ? savedAppid! : ""
        let baseurl: String = savedBaseurl != nil ? savedBaseurl! : ""
        
        SCGPush.start(withAccessToken: token, appId: appid, callbackUri: baseurl, delegate: nil)

        if let groupDefaults:UserDefaults = UserDefaults(suiteName: "group.com.syniverse.scg.push.demo") {
            groupDefaults.set(token, forKey: "scg-push-token")
            groupDefaults.set(appid, forKey: "scg-push-appid")
            groupDefaults.set(baseurl, forKey: "scg-push-baseurl")
            
        } else {
            debugPrint("Error: [SCGPush] could not access defaults with suite group.com.syniverse.scg.push.demo")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            }
            
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        UserDefaults.standard.set(tokenString, forKey: "apnTokenString")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    var notificationNumber:Int = 0
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let aps:NSDictionary? = userInfo["aps"] as? NSDictionary
        
        if aps != nil {
            if let silent:Int = aps?["content-available"] as? Int {
                
                if silent == 1 {
                    debugPrint("pushing to inbox")
                    SCGPush.sharedInstance().push(toInbox: userInfo)
                    
                    completionHandler(UIBackgroundFetchResult.newData)
                    return
                }
            }
            else {
                
                if (UserDefaults.standard.bool(forKey: "reporton")) {
                    if let messageID:String = userInfo["scg-message-id"] as? String
                    {
                        SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.read, completionBlock: {
                            debugPrint("You successfully send interaction Confirmation.")
                        }, failureBlock: { (error) in
                            debugPrint("Error reportStatus: \(error?.localizedDescription)")
                        })
                    }
                }
            }
        }
        
        
    }
    
    func showAlert(_ title:String, mess:String){
        let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        DispatchQueue.main.async {
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
}

