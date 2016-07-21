//
//  SCGPush.swift
//  SCGPush
//
//  Created by Slav Sarafski on 6/12/16.
//  Copyright © 2016 Spirit Invoker. All rights reserved.
//

import UIKit

public class SCGPush: NSObject {
    
    // PRIVATE VARIABLES
    private var _accessToken:String = ""
    
    // PUBLIC VARIABLES
    public var accessToken:String
    {
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: ("scg-access-token-dont-replace-this-default"))
            _accessToken = newValue
        }
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            _accessToken = defaults.stringForKey("scg-access-token-dont-replace-this-default")!
            return _accessToken
        }
    }
    
    public var appID:String = ""
    
    public var callbackURI:String = ""
    
    // PRIVATE VARIABLES
    private let tokenType = "APN"
    
    public static let instance = SCGPush()
    
    public override init (){
        
    }
    
    public func registerPushToken(deviceTokeData data:NSData, completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        
        let tokenChars = UnsafePointer<CChar>(data.bytes)
        var pushToken = ""
        for i in 0..<data.length {
            pushToken += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            
        }
        
        registerPushToken(pushToken, completionBlock: completionBlock, failureBlock: failureBlock)
    }
    
    public func registerPushToken(deviceToken:String, completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        saveDeviceToken(deviceToken: deviceToken)
        
        registerPushToken(completionBlock, failureBlock: failureBlock)
    }
    
    public func registerPushToken(completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.stringForKey("scg-push-token-dont-replace-this-default") == nil) {
            return
        }
        
        let deviceToken:String = defaults.stringForKey("scg-push-token-dont-replace-this-default")!
        
        
        let params = ["app_id":appID,
                      "type":tokenType,
                      "token":deviceToken] as Dictionary<String, AnyObject>
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let urlString = "\(callbackURI)/push_tokens/register"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse, _ = data
                else {
                    //print("error: not a valid http response")
                    if (failureBlock != nil) {
                        failureBlock! (error)
                    }
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                if (completionBlock != nil) {
                    completionBlock! ()
                }
            case 204:
                if (completionBlock != nil) {
                    completionBlock! ()
                }
                
            default:
                if (failureBlock != nil) {
                    let errorSend = NSError(domain: (httpResponse.URL?.absoluteString)!, code: httpResponse.statusCode, userInfo: nil)
                    failureBlock! (errorSend)
                }
            }
        }
        dataTask.resume()
    }

    public func unregisterPushToken(completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let pushToken:String = defaults.stringForKey("scg-push-token-dont-replace-this-default")! as String
        
        let params = ["app_id":appID,
                      "type":tokenType,
                      "token": pushToken] as Dictionary<String, String>
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let urlString = "\(callbackURI)/push_tokens/unregister"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse, _ = data
                else {
                    //print("error: not a valid http response")
                    if (failureBlock != nil) {
                        failureBlock! (error)
                    }
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                defaults.removeObjectForKey("scg-push-token-dont-replace-this-default")
                if (completionBlock != nil) {
                    completionBlock! ()
                }
            case 204:
                defaults.removeObjectForKey("scg-push-token-dont-replace-this-default")
                if (completionBlock != nil) {
                    completionBlock! ()
                }
                
            default:
                if (failureBlock != nil) {
                    let errorSend = NSError(domain: (httpResponse.URL?.absoluteString)!, code: httpResponse.statusCode, userInfo: nil)
                    failureBlock! (errorSend)
                }
            }
        }
        dataTask.resume()
    }
    //[NSObject : AnyObject]
    public func deliveryConfirmation(userInfo userInfo:NSDictionary ,completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        if let messageID = userInfo["scg-message-id"] {
            deliveryConfirmation(messageID as! String, completionBlock: completionBlock, failureBlock: failureBlock)
        }
    }
    
    public func deliveryConfirmation(messageID:String ,completionBlock: (() -> Void)? = nil, failureBlock : (NSError! -> ())? = nil) {
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let urlString = "\(callbackURI)/messages/\(messageID)/delivery_confirmation"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            
            guard let httpResponse = response as? NSHTTPURLResponse, _ = data
                else {
                    if (failureBlock != nil) {
                        failureBlock! (error)
                    }
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                if (completionBlock != nil) {
                    completionBlock! ()
                }
            case 204:
                if (completionBlock != nil) {
                    completionBlock! ()
                }
                
            default:
                if (failureBlock != nil) {
                    let errorSend = NSError(domain: (httpResponse.URL?.absoluteString)!, code: httpResponse.statusCode, userInfo: nil)
                    failureBlock! (errorSend)
                }
            }
        }
        dataTask.resume()
    }
    
    public func saveDeviceToken(deviceTokenData tokenData:NSData) {
        let tokenChars = UnsafePointer<CChar>(tokenData.bytes)
        var pushToken = ""
        for i in 0..<tokenData.length {
            pushToken += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(pushToken, forKey: "scg-push-token-dont-replace-this-default")
    }
    
    public func saveDeviceToken(deviceToken token:NSString) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: "scg-push-token-dont-replace-this-default")
    }
}
