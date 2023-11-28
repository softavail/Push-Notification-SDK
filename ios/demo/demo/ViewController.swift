//
//  ViewController.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit
import SCGPushSDK

class ViewController: UIViewController {

    @IBOutlet weak var accessTokenField: UITextField!
    @IBOutlet weak var appIDField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var resetBadge: UIButton!
    
    var baseURL:String = ""
    var isUserRegistered: Bool = false
    var isRegistering: Bool = false
    var isResetting: Bool = false
    
    func updateUI() {
        self.inboxButton.isHidden = !self.isUserRegistered
        self.resetBadge.isHidden = !self.isUserRegistered
        if isUserRegistered {
            self.registerButton.setTitle("Unregister", for: .normal)
            
        }
        else {
            self.registerButton.setTitle("Register", for: .normal)
        }
        
        if(isRegistering || isResetting) {
            self.enableAllButtons(false)
            self.activityIndicator.startAnimating()
//            self.activityIndicator.isHidden = false
        }
        else {
            self.enableAllButtons(true)
            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.enableAllButtons(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.activityIndicator.isHidden = true
        self.registerButton.contentHorizontalAlignment = .center
        
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = UIColor.blue.cgColor
        
        self.inboxButton.layer.cornerRadius = 10
        self.inboxButton.layer.borderWidth = 1
        self.inboxButton.layer.borderColor = UIColor.blue.cgColor
        
        self.resetBadge.layer.cornerRadius = 10
        self.resetBadge.layer.borderWidth = 1
        self.resetBadge.layer.borderColor = UIColor.blue.cgColor
        
        let defauts = UserDefaults.standard

        if (defauts.object(forKey: "appid") == nil) {
            defauts.set("", forKey: "appid")
        }
        
        if (defauts.object(forKey: "token") != nil) {
            accessTokenField.text = defauts.string(forKey: "token")
        }
        else {
            accessTokenField.text = ""
        }
//        if (defauts.object(forKey: "reporton") != nil) {
//            reportSwith.isOn = defauts.bool(forKey: "reporton")
//        }
//        else {
//            reportSwith.isOn = true
//            defauts.set(true, forKey: "reporton")
//        }
        
        //baseURIField.text = defauts.string(forKey: "baseurl")
        appIDField.text = defauts.string(forKey: "appid")
        
        SCGPush.sharedInstance().delegate = self
        //SCGPush.shared.delegate = self
//        SCGPush.shared.resolveTrackedLink("https://app.partners1993.com:8088/scg-link/5idWpd")
        
//        logField.layer.borderColor = UIColor.black.cgColor
//        logField.layer.borderWidth = 1
        //SLAV
//        SCGPush.instance.groupBundle = "group.com.syniverse.scg.push.demo"
//        SCGPush.instance.accessToken = "DQHlNta2J2QGHFHkI44Ei"
//        SCGPush.instance.appID = "com.syniverse.push_demo"
//        SCGPush.instance.callbackURI = "http://192.168.1.197:8080/scg-dra/proxy"
//        SCGPush.instance.callbackURI = "http://95.158.130.102:8080/scg-dra/proxy/"
        
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        let defauts = UserDefaults.standard
        if (sender.tag == 7){
            SCGPush.sharedInstance().accessToken = accessTokenField.text!
            defauts.set(accessTokenField.text!, forKey: "token")
        }
        if (sender.tag == 8){
            SCGPush.sharedInstance().appID = appIDField.text!
            defauts.set(appIDField.text!, forKey: "appid")
        }
//        if (sender.tag == 9) {
//            SCGPush.sharedInstance().callbackURI = baseURIField.text!
//            defauts.set(baseURIField.text!, forKey: "baseurl")
//        }
    }


    
    
    @IBAction func registerToken(_ sender: AnyObject) {
        accessTokenField.resignFirstResponder()
//        baseURIField.resignFirstResponder()
        appIDField.resignFirstResponder()
        
        
        
        
        guard let token = UserDefaults.standard.string(forKey: "apnTokenString") else {
            //TODO: Show teh error to teh user
            return
        }
        
        debugPrint("token: \(token)")
        if(!self.isUserRegistered) {
            
            self.isRegistering = true
            self.updateUI()
            
            SCGPush.sharedInstance().registerToken(token, withCompletionHandler: { (registeredToken) in
                //self.showAlert ("Success", mess: "You successfully register the token.")
                
                self.isRegistering = false
                self.isUserRegistered = true
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }) { (error) in
                
                self.isRegistering = false
                self.isUserRegistered = false
                
                self.showAlert ("Error", mess: (error?.localizedDescription)!)
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
        else {
            
            self.isRegistering = true
            self.updateUI()
            
            SCGPush.sharedInstance().unregisterPushToken(token, withCompletionHandler: { (registeredToken) in
                //self.showAlert ("Success", mess: "You successfully register the token.")
                
                self.isRegistering = false
                self.isUserRegistered = false
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }) { (error) in
                //self.showAlert ("Error", mess: (error?.localizedDescription)!)
                self.isRegistering = false
                self.isUserRegistered = false
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    

    
    @IBAction func didPressInboxButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginCompleteSegue", sender: nil)
        
    }

    @IBAction func didPressResetBadgeButton(_ sender: UIButton) {
        let token: String = UserDefaults.standard.string(forKey: "apnTokenString")!
        self.isResetting = true
        self.updateUI()
        SCGPush.sharedInstance().resetBadge(forPushToken: token) { (success, error) in
            self.isResetting = false
            DispatchQueue.main.async {
                self.updateUI()
            }
            
            if(success) {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
    }
    
    
    func showAlert(_ title:String, mess:String){
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func enableAllButtons(_ enable: Bool) {
        DispatchQueue.main.async {
            self.accessTokenField.isEnabled = enable
            self.appIDField.isEnabled = enable
            self.registerButton.isEnabled = enable
            self.settingsButton.isEnabled = enable
            self.inboxButton.isEnabled = enable
            self.resetBadge.isEnabled = enable
        }
    }

    func openLinkInBrowser(_ link: String) {
        let url = URL(string:link)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
}


extension ViewController: SCGPushSDK.SCGPushDelegate {
    func resolveTrackedLinkDidSuccess(_ redirectLocation: String!, withrequest request: URLRequest!) {
        DispatchQueue.main.async {
            debugPrint("RedirectionLocation: \(redirectLocation)\n")
            self.openLinkInBrowser(redirectLocation)
        }
    }
    
    func resolveTrackedLinkHasNotRedirect(_ request: URLRequest!) {
        DispatchQueue.main.async {
            debugPrint("RedirectionLocation: None\n")
        }
    }
}
