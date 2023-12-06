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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = .white
        
        if #available(iOS 10.0, *) {
            // use the feature only available in iOS 10
            let center = UNUserNotificationCenter.current() as UNUserNotificationCenter
            setUNUserNotificationCenterDelegate(center)
            setUNUserNotificationCenterCategroies()
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (granted, error) in
                DispatchQueue.main.async {
                    if granted {
                        application.registerForRemoteNotifications()
                    }
                }
                if error != nil {
                    debugPrint(error?.localizedDescription ?? "Unknown")
                }
            }
        } else {

            // or use some work around
            let categoryIncomingCall:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            categoryIncomingCall.identifier = "categoryLink"
            
            let actionAnswer:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            actionAnswer.identifier = "actionLink"
            actionAnswer.title = "Link"
            actionAnswer.activationMode = UIUserNotificationActivationMode.foreground
            
            categoryIncomingCall.setActions([actionAnswer], for: UIUserNotificationActionContext.default)
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: [categoryIncomingCall])
            application.registerUserNotificationSettings(settings)
        }
        
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
        debugPrint("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("applicationWillEnterForeground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("applicationWillEnterForeground")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Updated 1 old function

//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != UIUserNotificationType() {
//            application.registerForRemoteNotifications()
//        }
//    }
    
    private func application(_ application: UIApplication, didRegister notificationSettings: UNAuthorizationOptions) {
        if notificationSettings != UNAuthorizationOptions() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "apnTokenString")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    var notificationNumber:Int = 0
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("did receive remote notification")
        let aps:NSDictionary? = userInfo["aps"] as? NSDictionary
        
        let sn:Bool? = userInfo["show-notification"] as? Bool
        
        if aps != nil {
            if let silent:Int = aps?["content-available"] as? Int {
                
                if silent == 1 {
                    
                    // check badge value
                    let badge:Int? = aps?["badge"] as? Int
                    
                    if badge != nil {
                        debugPrint("set badge number to \(badge!)")
                        application.applicationIconBadgeNumber = badge!
                    }
                    
                    if sn != nil && sn! == true {
                        debugPrint("showing notification")

                        if (UserDefaults.standard.bool(forKey: "reporton")) {
                            if let messageID:String = userInfo["scg-message-id"] as? String
                            {
                                SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.delivered, completionBlock: {
                                    debugPrint("Successfully reportStatus  withMessageId: \(messageID)")
                                }, failureBlock: { (error) in
                                    debugPrint("Error reportStatus  withMessageId: \(messageID), error: \((error?.localizedDescription)!)")
                                })
                            }
                        }

                        showSilentNotification(userInfo, fetchCompletionHandler: completionHandler)
                        
                    } else {
                        debugPrint("pushing to inbox")
                        SCGPush.sharedInstance().push(toInbox: userInfo)

                        if (UserDefaults.standard.bool(forKey: "reporton")) {
                            if let messageID:String = userInfo["scg-message-id"] as? String
                            {
                                SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.delivered, completionBlock: {
                                    debugPrint("Successfully reportStatus  withMessageId: \(messageID)")
                                    completionHandler(UIBackgroundFetchResult.newData)
                                }, failureBlock: { (error) in
                                    debugPrint("Error reportStatus  withMessageId: \(messageID), error: \((error?.localizedDescription)!)")
                                    completionHandler(UIBackgroundFetchResult.failed)
                                })
                            } else {
                                completionHandler(UIBackgroundFetchResult.newData)
                            }
                        } else {
                            completionHandler(UIBackgroundFetchResult.newData)
                        }
                    }
                }
            } else {
                if let url:String = userInfo["deep_link"] as? String
                {
                    SCGPush.sharedInstance().resolveTrackedLink(url)
                }

                if (UserDefaults.standard.bool(forKey: "reporton")) {
                    if let messageID:String = userInfo["scg-message-id"] as? String
                    {
                        SCGPush.sharedInstance().reportStatus(withMessageId: messageID, andMessageState: MessageState.read, completionBlock: {
                            debugPrint("Successfully reportStatus  withMessageId: \(messageID)")
                        }, failureBlock: { (error) in
                            debugPrint("Error reportStatus  withMessageId: \(messageID), error: \((error?.localizedDescription)!)")
                        })
                    }
                }
            }
        }
    }
    
    // MARK: Updated 2 old functions
    
//    func application(_ application: UIApplication,
//                     didReceive notification: UILocalNotification)
//    {
//        if let category = notification.category {
//            if category == "categoryLink" {
//                debugPrint("Tapped in notification with deep link")
//            }
//        }
//    }
    
    private func application(_ application: UIApplication, didReceive notification: UNNotificationRequest) {
        let category = notification.content.categoryIdentifier
        if category == "categoryLink" {
            debugPrint("Tapped in notification with deep link")
        }
    }

//    func application(_ application: UIApplication,
//                     handleActionWithIdentifier identifier: String?,
//                     for notification: UILocalNotification,
//                     completionHandler: @escaping () -> Void)
//    {
//        if let category = notification.category {
//            if category == "categoryLink" {
//                if let action = identifier {
//                    if action == "actionLink" {
//                        debugPrint("Tapped in deep link")
//                        if let url:String = notification.userInfo?["deep_link"] as? String
//                        {
//                            debugPrint("Will resolve deep link")
//                            SCGPush.sharedInstance().resolveTrackedLink(url)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    private func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UNNotificationRequest, completionHandler: @escaping () -> Void) {
        let category = notification.content.categoryIdentifier
        if category == "categoryLink" {
            if let action = identifier {
                if action == "actionLink" {
                    debugPrint("Tapped in deep link")
                    let userInfo = notification.content.userInfo
                    if let url: String = userInfo["deep_link"] as? String {
                        debugPrint("Will resolve deep link")
                        SCGPush.sharedInstance().resolveTrackedLink(url)
                    }
                }
            }
        }
    }
    
    func showSilentNotification(_ userInfo: [AnyHashable : Any],
                                fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void ) {
        if #available(iOS 10.0, *) {

            let body: String = (userInfo["body"] as? String)!
            
            if let messageID = userInfo["scg-message-id"] as? String {
                if let attachmentID = userInfo["scg-attachment-id"] as? String {
                    showMediaNotification(body, messageID: messageID, attachmentID: attachmentID,
                                          userInfo: userInfo,
                                          fetchCompletionHandler: completionHandler)
                } else {
                    showTextNotification(withMessageId: messageID, andBody: body, userInfo: userInfo)
                    completionHandler(UIBackgroundFetchResult.noData)
                }
            }
        } else {
            // show notificaiton locally
            let localNotification = UILocalNotification()
            localNotification.alertBody = userInfo["body"] as! String?
            localNotification.fireDate = Date().addingTimeInterval(1)
            localNotification.userInfo = userInfo

            if (userInfo["deep_link"] != nil) {
                localNotification.category = "categoryLink"
            }
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
    
    @available( iOS 10.0, *)
    func showMediaNotification(_ title: String, messageID: String, attachmentID: String,
                               userInfo: [AnyHashable : Any],
                               fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        SCGPush.sharedInstance().loadAttachment(withMessageId: messageID,
                                                andAttachmentId: attachmentID,
                                                completionBlock: { (contentUrl, contentType) in
                                                    debugPrint("loadAttachment \(attachmentID) succeeded")
                                                    let content = UNMutableNotificationContent()
                                                    content.body = title
                                                    content.userInfo = userInfo
                                                    
                                                    if (userInfo["deep_link"] != nil) {
                                                        content.categoryIdentifier = "categoryLink"
                                                    }
                                                    
                                                    let attachment: UNNotificationAttachment?
                                                    
                                                    do {
                                                        debugPrint("will try to create UNNotificationAttachment with url: \(contentUrl.debugDescription)")
                                                        debugPrint("contentType: \(contentType)")
                                                        let options = [UNNotificationAttachmentOptionsTypeHintKey: contentType];
                                                        attachment = try UNNotificationAttachment(identifier: attachmentID,
                                                                                                  url: contentUrl,
                                                                                                  options: options)
                                                        debugPrint("add attachment with url: \(contentUrl.debugDescription)")
                                                        content.attachments.append(attachment!)
                                                    } catch let error {
                                                        debugPrint("failed to create UNNotificationAttachment with error: \(error.localizedDescription)")
                                                    }

                                                    let request = UNNotificationRequest(identifier: messageID, content: content, trigger: nil)
                                                    UNUserNotificationCenter.current().add(request) { error in
                                                        if (error != nil){
                                                            debugPrint("failed to show notification with error: \(error?.localizedDescription ?? "Unknown")")
                                                        }
                                                    }
                                                    completionHandler(UIBackgroundFetchResult.newData)
                                                },
                                                failureBlock: { (error) in
                                                    debugPrint("loadAttachment \(attachmentID) failed with error: \(error?.localizedDescription ?? "Unknown")")
                                                    self.showTextNotification(withMessageId: messageID,  andBody: title, userInfo: userInfo)
                                                    completionHandler(UIBackgroundFetchResult.failed)
                                                })
    }
    
    @available( iOS 10.0, *)
    func showTextNotification(withMessageId messageId: String, andBody body: String, userInfo: [AnyHashable : Any]) {
        let content = UNMutableNotificationContent()
        content.body = body
        content.userInfo = userInfo
        
        if (userInfo["deep_link"] != nil) {
            content.categoryIdentifier = "categoryLink"
        }
        
        let request = UNNotificationRequest(identifier: messageId, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if (error != nil){
                //handle here
            }
        }
    }
    
    func showAlert(_ title:String, mess:String){
        let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        DispatchQueue.main.async {
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    public func setUNUserNotificationCenterCategroies() {
        // Add action.
        let linkAction = UNNotificationAction(identifier: "actionLink", title: "Link", options: [UNNotificationActionOptions.foreground])
        
        // Create category.
        let category = UNNotificationCategory(identifier: "categoryLink", actions: [linkAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    public func setUNUserNotificationCenterDelegate(_ center: UNUserNotificationCenter) {
        center.delegate = self
    }
    public func unsetUNUserNotificationCenterDelegate(_ center: UNUserNotificationCenter) {
        center.delegate = nil
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        debugPrint("willPresent notification")
        completionHandler( [.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        if (response.actionIdentifier == UNNotificationDefaultActionIdentifier) {
            debugPrint("Tapped in notification")
        } else if (response.actionIdentifier == "actionLink") {
            debugPrint("Tapped in deep link")
            
            if let url:String = response.notification.request.content.userInfo["deep_link"] as? String
            {
                debugPrint("Will resolve deep link")
                SCGPush.sharedInstance().resolveTrackedLink(url)
            }
        } else if (response.actionIdentifier == UNNotificationDismissActionIdentifier) {
            debugPrint("dismissed notification")
        }
        
        completionHandler()
    }
}


