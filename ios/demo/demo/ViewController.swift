//
//  ViewController.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var rawPushTokenLabel: UILabel!
    @IBOutlet weak var purePushTokenLabel: UILabel!
    @IBOutlet weak var accessTokenField: UITextField!
    
    var baseURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        accessTokenField.text = "ELK2c5Lwzx9JI5l4iLA0F4"
        //purePushTokenLabel.text = "87d0e8f7cf0db78b90naf3e994ca057b8e91c2d25ffdf801ef85a312c5e3354"
        
        baseURL = "http://localhost:8912"
        baseURL = "192.168.1.197:8080"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func clipboard(sender: AnyObject) {
        if (sender.tag == 11) {
            UIPasteboard.generalPasteboard().string = rawPushTokenLabel.text
        }
        if (sender.tag == 12) {
            UIPasteboard.generalPasteboard().string = purePushTokenLabel.text
        }
    }
    
    
    
    @IBAction func registerToken(sender: AnyObject) {
        if (purePushTokenLabel!.text == "") {
            self.warningLabel.textColor = UIColor.yellowColor()
            warningLabel!.text = "Please enter an access token"
            return
        }
        warningLabel!.text = ""
        
        let accessToken:String = accessTokenField.text!
        let pushToken:String = purePushTokenLabel.text!
        
        let params = ["app_id":"com.syniverse.demo", "type":"APN", "token":pushToken] as Dictionary<String, AnyObject>
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let urlString = "\(baseURL)/scg-dra/proxy/push_tokens/register"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        print ("register sended \(accessToken)")
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            print (response)
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? NSHTTPURLResponse, _ = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
//            let respond = NSString (data: receivedData, encoding: NSUTF8StringEncoding)
            var jsonResults:AnyObject?
            do {
                jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print (jsonResults)
            } catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                print ("ura")
                dispatch_async(dispatch_get_main_queue(), {
                    let tokenID:String = jsonResults!["id"] as! String
                    self.warningLabel.textColor = UIColor.greenColor()
                    self.warningLabel.text = "Successful registered push token. ID:\(tokenID)"
                })
                
            default:
                if ((jsonResults) != nil) {
                    print (jsonResults!["description"])
                    self.warningLabel.textColor = UIColor.redColor()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.warningLabel.text = "Error \(jsonResults!["description"])"
                    })
                }
                print("save profile POST request got response \(httpResponse.statusCode)")
            }
        }
        dataTask.resume()
    }
    
    @IBAction func unregisterToken(sender: AnyObject) {
        if (purePushTokenLabel!.text == "") {
            self.warningLabel.textColor = UIColor.yellowColor()
            warningLabel!.text = "Please enter an access token"
            return
        }
        warningLabel!.text = ""
        
        let accessToken:String = accessTokenField.text!
        let pushToken:String = purePushTokenLabel.text!
        
        let params = ["token":pushToken] as Dictionary<String, AnyObject>
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        //94.236.128.158
        let urlString = "\(baseURL)/scg-dra/proxy/push_tokens/unregister"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        print ("sended unregistering")
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            print (response)
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? NSHTTPURLResponse, _ = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
//            let respond = NSString (data: receivedData, encoding: NSUTF8StringEncoding)
            var jsonResults:AnyObject?
            do {
                jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print (jsonResults)
            } catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.warningLabel.textColor = UIColor.greenColor()
                    self.warningLabel.text = "Successful UNregistered push token"
                })
                
            default:
                if ((jsonResults) != nil) {
                    print (jsonResults!["description"])
                    self.warningLabel.textColor = UIColor.redColor()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.warningLabel.text = "Error \(jsonResults!["description"])"
                    })
                }
                print("save profile POST request got response \(httpResponse.statusCode)")
            }
        }
        dataTask.resume()
    }
    
    @IBAction func retriveAccessToken(sender: AnyObject) {
        warningLabel!.text = ""
        
        let params = ["duration":"3600"] as Dictionary<String, AnyObject>
        
        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        //94.236.128.158
        let urlString = "\(baseURL)/scg-external-api/api/v1/contacts/ciUiexQdTcWTpqAR-QI5jQ/access_tokens"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        
        request.addValue("99999", forHTTPHeaderField: "int-companyId")
        request.addValue("888", forHTTPHeaderField: "int-appId")
        request.addValue("bogus-transaction-id", forHTTPHeaderField: "int-txnId")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let dataTask = session.dataTaskWithRequest(request)
        {
            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
            print (response)
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            let respond = NSString (data: receivedData, encoding: NSUTF8StringEncoding)
            var jsonResults:AnyObject?
            do {
                jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print (jsonResults)
            } catch {
                // failure
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                dispatch_async(dispatch_get_main_queue(), {
                    self.warningLabel.textColor = UIColor.greenColor()
                    self.warningLabel.text = "Successful retrived access token"
                    self.accessTokenField.text = jsonResults!["id"] as? String
                })
                break
            default:
                if ((jsonResults) != nil) {
                    print (jsonResults!["description"])
                    self.warningLabel.textColor = UIColor.redColor()
                    if ((jsonResults!["description"]) != nil) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.warningLabel.text = "Error \(jsonResults!["description"])"
                        })
                    }
                    if ((jsonResults!["error_description"]) != nil) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.warningLabel.text = "Error \(jsonResults!["error_description"])"
                        })
                    }
                }
                print("save profile POST request got response \(httpResponse.statusCode)")
            }
        }
        dataTask.resume()
    }
}

