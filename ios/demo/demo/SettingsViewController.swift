//
//  SettingsViewController.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/16/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit
import SCGPushSDK

class SettingsViewController: UIViewController, SCGPushSDK.SCGPushDelegate {
    @IBOutlet weak var baseUriTextField: UITextField!
    @IBOutlet weak var interactionReportLabel: UILabel!
    @IBOutlet weak var interactionReportSwitch: UISwitch!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var clipboardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defauts = UserDefaults.standard
        
        if (defauts.object(forKey: "baseurl") == nil) {
            defauts.set("http://192.168.1.197:8080/scg-dra/proxy", forKey: "baseurl")
            
        }
        if (defauts.object(forKey: "reporton") != nil) {
            interactionReportSwitch.isOn = defauts.bool(forKey: "reporton")
        }
        else {
            interactionReportSwitch.isOn = true
            defauts.set(true, forKey: "reporton")
        }
        
        baseUriTextField.text = defauts.string(forKey: "baseurl")
        tokenLabel.text = defauts.string(forKey: "apnTokenString")
        
        SCGPush.sharedInstance().callbackURI = baseUriTextField.text!


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTextFieldChanged(_ sender: UITextField) {
        let defauts = UserDefaults.standard
        if (sender.tag == 9) {
            SCGPush.sharedInstance().callbackURI = baseUriTextField.text!
            defauts.set(baseUriTextField.text!, forKey: "baseurl")
        }
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "reporton")
    }
    
    
    @IBAction func didPressCopyButton(_ sender: UIButton) {
        UIPasteboard.general.string = tokenLabel.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
