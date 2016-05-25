//
//  ViewController.swift
//  demo
//
//  Created by Asen Lekov on 5/16/16.
//  Copyright © 2016 softavail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func clipboard(sender: AnyObject) {
        if (sender.tag == 11) {
            UIPasteboard.generalPasteboard().string = (view.viewWithTag(8) as! UILabel).text
        }
        if (sender.tag == 12) {
            UIPasteboard.generalPasteboard().string = (view.viewWithTag(9) as! UILabel).text
        }
    }
}

