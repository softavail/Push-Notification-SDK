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
    @IBOutlet weak var reportSwith: UISwitch!
    
    var baseURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defauts = UserDefaults.standard
        print (defauts.object(forKey: "baseurl"))
        if (defauts.object(forKey: "baseurl") == nil) {
            defauts.set("http://192.168.1.197:8080/scg-dra/proxy", forKey: "baseurl")
            
        }
        if (defauts.object(forKey: "appid") == nil) {
            defauts.set("com.syniverse.push_demo", forKey: "appid")
        }
        if (defauts.object(forKey: "token") != nil) {
            accessTokenField.text = defauts.string(forKey: "token")
        }
        else {
            accessTokenField.text = ""
        }
        if (defauts.object(forKey: "reporton") != nil) {
            reportSwith.isOn = defauts.bool(forKey: "reporton")
        }
        else {
            reportSwith.isOn = true
            defauts.set(true, forKey: "reporton")
        }
        
        baseURIField.text = defauts.string(forKey: "baseurl")
        appIDField.text = defauts.string(forKey: "appid")
        
        SCGPush.instance.groupBundle = "group.com.softavail.scg.push.demo.group"
        SCGPush.instance.callbackURI = baseURIField.text!
        SCGPush.instance.appID = appIDField.text!
        SCGPush.instance.accessToken = accessTokenField.text!

        //SLAV
//        SCGPush.instance.groupBundle = "group.com.softavail.scg.push.demo.group"
//        SCGPush.instance.accessToken = "DQHlNta2J2QGHFHkI44Ei"
//        SCGPush.instance.appID = "com.syniverse.push_demo"
//        SCGPush.instance.callbackURI = "http://192.168.1.197:8080/scg-dra/proxy"
//        SCGPush.instance.callbackURI = "http://95.158.130.102:8080/scg-dra/proxy/"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        let defauts = UserDefaults.standard
        if (sender.tag == 7){
            SCGPush.instance.accessToken = accessTokenField.text!
            defauts.set(accessTokenField.text!, forKey: "token")
        }
        if (sender.tag == 8){
            SCGPush.instance.appID = appIDField.text!
            defauts.set(appIDField.text!, forKey: "appid")
        }
        if (sender.tag == 9) {
            SCGPush.instance.callbackURI = baseURIField.text!
            defauts.set(baseURIField.text!, forKey: "baseurl")
        }
    }
    
    @IBAction func clipboard(_ sender: AnyObject) {
        UIPasteboard.general.string = purePushTokenLabel.text
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
    
    @IBAction func reportSwitchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "reporton")
    }
    
    func showAlert(_ title:String, mess:String){
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

