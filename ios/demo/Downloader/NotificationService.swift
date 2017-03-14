//
//  NotificationService.swift
//  Downloader
//
//  Created by Slav Sarafski on 26/10/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UserNotifications
import SCGPushSDK
import MobileCoreServices

@available(iOSApplicationExtension 10.0, *)
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
 
        SCGPush.sharedInstance().groupBundle = "group.com.syniverse.scg.push.demo"
        
        if let attachmentID = request.content.userInfo["scg-attachment-id"] as? String, let messageID = request.content.userInfo["scg-message-id"] as? String {
            // Download the attachment
            print("step 2", attachmentID, messageID)

            SCGPush.sharedInstance().loadAttachment(withMessageId: messageID, andAttachmentId: attachmentID, completionBlock: { (contentUrl, contentType) in
                print("tmp", contentType)
                
                let options = [UNNotificationAttachmentOptionsTypeHintKey: contentType]
                if let attachment = try? UNNotificationAttachment(identifier: "video", url: contentUrl, options: options) {
                    self.bestAttemptContent?.attachments = [attachment]
                }
                self.contentHandler!(self.bestAttemptContent!)
            }, failureBlock: { (error) in
                print("load error", error!)
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
