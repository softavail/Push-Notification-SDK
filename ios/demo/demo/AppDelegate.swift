//
//  AppDelegate.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit
import SCGPush

#if WITH_CRASHLYTICS
    import Fabric
    import Crashlytics
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        #if WITH_CRASHLYTICS
        Fabric.with([Crashlytics.self])
        #endif

        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        let tokenPureString = "\(deviceToken)"
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            
        }
        print (tokenString)
        (window?.rootViewController!.view.viewWithTag(8) as! UILabel).text = tokenPureString
        (window?.rootViewController!.view.viewWithTag(9) as! UILabel).text = tokenString
        
        SCGPush.instance.saveDeviceToken(deviceTokenData: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    var notificationNumber:Int = 0
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        
//        notificationNumber += 1
//        application.applicationIconBadgeNumber =  notificationNumber;
        
        if ((window?.rootViewController!.view.viewWithTag(24) as! UISwitch).on) {
        SCGPush.instance.deliveryConfirmation(userInfo: userInfo, completionBlock: {
            self.showAlert ("Success", mess: "You successfully send deliveryConfirmation.")
            }) { (error) in
                self.showAlert ("Error", mess: error.description)
        }
        }
        
        if let aps = userInfo["aps"] as? NSDictionary {
            print("my messages : \(aps["alert"])")
            (window?.rootViewController!.view.viewWithTag(10) as! UILabel).text = aps["alert"] as? String
        }
    }
    
    func showAlert(title:String, mess:String){
        let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:nil))
        window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }
}

