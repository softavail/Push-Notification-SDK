//
//  NotificationService.swift
//  Downloader
//
//  Created by Slav Sarafski on 26/10/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UserNotifications
import SCGPush

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            //bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            //contentHandler(bestAttemptContent)
        }
        print("step 1",request.content.userInfo)
        
        if let urlString = request.content.userInfo["scgg-attachment"] as? String {
                // Download the attachment
            print("step 2")
                SCGPush.instance.loadContentPresentation(urlString, completionBlock: {
                    (tmpUrl) in
                    print("tmp", tmpUrl)
                    if let attachment = try? UNNotificationAttachment(identifier: "image", url: tmpUrl) {
                        print("att", attachment)
                        self.bestAttemptContent?.attachments = [attachment]
                    }
                    self.contentHandler!(self.bestAttemptContent!)
                })
            
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            
            contentHandler(bestAttemptContent)
        }
    }

}
