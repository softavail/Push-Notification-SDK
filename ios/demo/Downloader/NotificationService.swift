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

enum ContentType {
    case audio
    case image
    case video
    case word
    case excel
    case powerPoint
    case pdf
    case defaultDocument
}

@available(iOSApplicationExtension 10.0, *)
class NotificationService: UNNotificationServiceExtension {

    var hasApppId: Bool = false
    var hasToken: Bool = false
    var hasBaseUrl: Bool = false
    
    override init () {
        super.init()
        
        if let defaults:UserDefaults = UserDefaults(suiteName: "group.com.syniverse.scg.push.demo") {
            
            if let appId = defaults.string(forKey: "scg-push-appid") as String? {
                debugPrint("Info: [SCGPush] successfully assigned appid")
                SCGPush.sharedInstance().appID = appId
                self.hasApppId = true
            }

            if let token = defaults.string(forKey: "scg-push-token") as String? {
                debugPrint("Info: [SCGPush] successfully assigned acces token")
                SCGPush.sharedInstance().accessToken = token
                self.hasToken = true
            }

            if let baseUrl = defaults.string(forKey: "scg-push-baseurl") as String? {
                debugPrint("Info: [SCGPush] successfully assigned baseurl")
                SCGPush.sharedInstance().callbackURI = baseUrl
                self.hasBaseUrl = true
            }
        } else {
            debugPrint("Error: [SCGPush] could not access defaults with suite group.com.syniverse.scg.push.demo")
        }
    }

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        guard let newContent = request.content.mutableCopy() as? UNMutableNotificationContent else { return }
        guard let attachmentURL = request.content.userInfo["scgg-attachment-id"] as? String else {
            contentHandler(request.content)
            return
        }
        
        downloadURLContent(from: attachmentURL) { localURL, urlType in
            if urlType == .audio || urlType == .image || urlType == .video {
                if let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: localURL) {
                    newContent.attachments = [attachment]
                } else {
                    debugPrint("Error: [SCGPush] could not create attachment from: \(attachmentURL)")
                }
            } else {
                debugPrint("Error: [SCGPush] could not create attachment from: \(attachmentURL)")
            }
            
            contentHandler(newContent)
        }
        
    }
    
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//
//        if !self.hasToken || !self.hasApppId || !self.hasBaseUrl {
//            debugPrint("Error: [SCGPush] wont load attachment cause baseurl, accesstoken or appid is missing")
//            contentHandler(request.content.copy() as! UNNotificationContent)
//        } else if let attachmentID = request.content.userInfo["scg-attachment-id"] as? String, let messageID = request.content.userInfo["scg-message-id"] as? String {
//            // Download the attachment
//            debugPrint("Notice: [SCGPush] will try to load attachment \(attachmentID) for message \(messageID)")
//            SCGPush.sharedInstance().loadAttachment(withMessageId: messageID, andAttachmentId: attachmentID, completionBlock: { (contentUrl, contentType) in
//                debugPrint("Info: [SCGPush] successfully loaded attachment with content-type: \(contentType)")
//                let bestAttemptContent:UNMutableNotificationContent = request.content.mutableCopy() as! UNMutableNotificationContent
//                
//                let options = [UNNotificationAttachmentOptionsTypeHintKey: contentType]
//                if let attachment = try? UNNotificationAttachment(identifier: attachmentID, url: contentUrl, options: options) {
//                    bestAttemptContent.attachments = [attachment]
//                } else {
//                    debugPrint("Error: [SCGPush] could not create attachment with content-type: \(contentType)")
//                }
//
//                contentHandler(bestAttemptContent)
//                
//            }, failureBlock: { (error) in
//                debugPrint("Error: [SCGPush] failed to load attachment: \(attachmentID)")
//                contentHandler(request.content.mutableCopy() as! UNMutableNotificationContent)
//            })
//        } else {
//            debugPrint("Error: [SCGPush] wont load attachment cause accesstoken or appid is missing")
//            contentHandler(request.content.copy() as! UNNotificationContent)
//        }
//    }
    
    override func serviceExtensionTimeWillExpire() {
        // No best attempt from us
    }
    
    // MARK: downloadURLContent methods
    
    func downloadURLContent(from urlString: String, completionHandler: @escaping (URL, ContentType) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var secureURLString = urlString
            if !urlString.hasPrefix("https") {
                secureURLString.insert("s", at: "https".firstIndex(of: "s")!)
            }
            
            guard let attachmentURL = URL(string: secureURLString) else { return }
            guard let urlData = NSData(contentsOf: attachmentURL) else { return }
            
            let fileExtension = attachmentURL.pathExtension.lowercased()
            let name = UUID().uuidString + "." + fileExtension
            guard let path = self?.getSharedDirectory()?.appendingPathComponent(name) else { return }
            
            let urlType: ContentType
            
            switch fileExtension {
            case "aiff", "aif", "aifc", "wav", "mp3", "m4a":
                urlType = .audio
            case "jpg", "jpeg", "jpe", "jif", "jfif", "pjpeg", "pjp", "gif", "png":
                urlType = .image
            case "mpg", "mp2", "mpeg", "mpe", "mpv", "m2v", "mp4", "m4p", "m4v", "avi":
                urlType = .video
            case "doc", "docx":
                urlType = .word
            case "xls", "xlsx":
                urlType = .excel
            case "ppt", "pptx":
                urlType = .powerPoint
            case "pdf":
                urlType = .pdf
            default:
                urlType = .defaultDocument
            }
            
            DispatchQueue.main.async {
                do {
                    try urlData.write(to: path)
                    completionHandler(path, urlType)
                } catch {
                    print("Failed writing to path.")
                }
            }
        }
    }
    
    func getSharedDirectory() -> URL? {
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.syniverse.push.demo.app")
        return path
    }
}
