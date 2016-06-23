//
//  ViewController.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit
import SCGPush

class ViewController: UIViewController {

    @IBOutlet weak var rawPushTokenLabel: UILabel!
    @IBOutlet weak var purePushTokenLabel: UILabel!
    @IBOutlet weak var accessTokenField: UITextField!
    @IBOutlet weak var baseURIField: UITextField!
    @IBOutlet weak var appIDField: UITextField!
    
    var baseURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        accessTokenField.text = "ELK2c5Lwzx9JI5l4iLA0F4"
//        purePushTokenLabel.text = "38ac1c3a36e9294ccca278f81798ecf872a33c0012c0af1c27fdf7ac207411ff"
        
//        baseURL = "http://localhost:8912"
//        baseURL = "192.168.1.197:8080"
        
        baseURIField.text = "http://192.168.1.197:8080/scg-dra/proxy"
        appIDField.text = "com.syniverse.push_demo"
        
//        SCGPush.instance.accessToken = "saFgvAco23YEkXKFhRX8Q-"
        SCGPush.instance.appID = "com.syniverse.push_demo"
        SCGPush.instance.callbackURI = "http://192.168.1.197:8080/scg-dra/proxy"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldChanged(sender: UITextField) {
        if (sender.tag == 7){
            SCGPush.instance.accessToken = accessTokenField.text!
        }
        if (sender.tag == 8){
            SCGPush.instance.appID = appIDField.text!
        }
        if (sender.tag == 9) {
            SCGPush.instance.callbackURI = baseURIField.text!
        }
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
        accessTokenField.resignFirstResponder()
        baseURIField.resignFirstResponder()
        appIDField.resignFirstResponder()
        
        SCGPush.instance.registerPushToken(purePushTokenLabel.text!, completionBlock: {
            self.showAlert ("Success", mess: "You successfully register the token.")
            }) { (error) in
                self.showAlert ("Error", mess: error.description)
        }
    }
    
    @IBAction func unregisterToken(sender: AnyObject) {
        accessTokenField.resignFirstResponder()
        baseURIField.resignFirstResponder()
        appIDField.resignFirstResponder()
        
        SCGPush.instance.unregisterPushToken({
            self.showAlert ("Success", mess: "You successfully unregister the token.")
            }) { (error) in
                self.showAlert ("Error", mess: error.description)
        }
    }
    
    func showAlert(title:String, mess:String){
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

