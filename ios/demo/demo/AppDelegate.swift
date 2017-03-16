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
        
        SCGPush.sharedInstance()
        
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
        (window?.rootViewController!.view.viewWithTag(9) as! UILabel).text = tokenString
        
        
        SCGPush.sharedInstance().registerToken(tokenString, withCompletionHandler: { (token) in
            
        }) { (error) in
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    var notificationNumber:Int = 0
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        application.applicationIconBadgeNumber =  0;

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
        }
        
        let rootController:ViewController = window?.rootViewController! as! ViewController
        
        if let alertMessage = aps?["alert"] as? String {
            print("my messages : \(alertMessage)")
            (rootController.view.viewWithTag(10) as! UILabel).text = alertMessage
        }
        
        if let url:String = userInfo["deep_link"] as? String
        {
            SCGPush.sharedInstance().resolveTrackedLink(url)
        }
        
        
        if let appdata = userInfo["app_data"] as? String {
            rootController.logField.text = rootController.logField.text.appending("AppData: \(appdata)\n")
        }
        
        if ((window?.rootViewController!.view.viewWithTag(24) as! UISwitch).isOn) {
            if (UserDefaults.standard.bool(forKey: "reporton")) {
                if let messageID:String = userInfo["scg-message-id"] as? String
                {
                    SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.read, completionBlock: {
                        self.showAlert ("Success", mess: "You successfully send interactionConfirmation.")
                    }, failureBlock: { (error) in
                        self.showAlert ("Error", mess: (error?.localizedDescription)!)
                    })
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

