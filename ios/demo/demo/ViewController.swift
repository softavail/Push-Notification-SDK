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

    @IBOutlet weak var purePushTokenLabel: UILabel!
    @IBOutlet weak var accessTokenField: UITextField!
    @IBOutlet weak var baseURIField: UITextField!
    @IBOutlet weak var appIDField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var baseURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        baseURIField.text = "http://192.168.1.197:8080/scg-dra/proxy"
        appIDField.text = "com.syniverse.push_demo"
        
        SCGPush.instance.groupBundle = "group.com.softavail.scg.push.demo.group"
        SCGPush.instance.accessToken = "DQHlNta2J2QGHFHkI44Ei"
        SCGPush.instance.appID = "com.syniverse.push_demo"
        SCGPush.instance.callbackURI = "http://192.168.1.197:8080/scg-dra/proxy"
        SCGPush.instance.callbackURI = "http://95.158.130.102:8080/scg-dra/proxy/"
        //SCGPush.instance.callbackURI = "http://localhost:8912/scg-dra/proxy"
        //SCGPush.instance.callbackURI = "http://192.168.1.102:8912/scg-dra/proxy"
//        SCGPush.instance.loadAttachment("7h0W48pb3XRmYT9L1TScc1", attachmentID: "LYT9CBu3TlIBLVgFP585J2", completionBlock: {
//            (tmpUrl) in
//            print ("ura", tmpUrl)
//            self.imageView.image = UIImage.init(contentsOfFile: tmpUrl.path)
//        }, failureBlock: {
//            (error) in
//            print ("error", error!)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
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
    
    @IBAction func clipboard(_ sender: AnyObject) {
        
        if (sender.tag == 12) {
            UIPasteboard.general.string = purePushTokenLabel.text
        }
    }
    
    
    @IBAction func registerToken(_ sender: AnyObject) {
        accessTokenField.resignFirstResponder()
        baseURIField.resignFirstResponder()
        appIDField.resignFirstResponder()
        
        SCGPush.instance.registerPushToken({
                self.showAlert ("Success", mess: "You successfully register the token.")
            }) { (error) in
                self.showAlert ("Error", mess: (error?.localizedDescription)!)
        }
    }
    
    @IBAction func unregisterToken(_ sender: AnyObject) {
        accessTokenField.resignFirstResponder()
        baseURIField.resignFirstResponder()
        appIDField.resignFirstResponder()
        
        SCGPush.instance.unregisterPushToken({
                self.showAlert ("Success", mess: "You successfully unregister the token.")
            }) { (error) in
                self.showAlert ("Error", mess: (error?.localizedDescription)!)
        }
    }
    
    func showAlert(_ title:String, mess:String){
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

