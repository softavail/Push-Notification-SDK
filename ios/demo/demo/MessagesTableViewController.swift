//
//  MessagesTableViewController.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/15/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit
import QuickLook
import SCGPushSDK
import MobileCoreServices

class MessagesTableViewController: UITableViewController, QLPreviewControllerDataSource, NotificationTableViewCellDelegate {
    
    func didClickDelivery(cell: UITableViewCell) {
        
    }
    
    func didClickRead(cell:UITableViewCell) {
        
    }
    
    func didClickThru(cell:UITableViewCell) {
        
    }
    
    func didClickDelete(cell:UITableViewCell) {
        
    }
    
    func didClickDeepLink(cell:UITableViewCell) {
        
    }
    
    func didClickAttachment(cell:UITableViewCell) {
        
    }


//    @IBOutlet weak var logOutButton: UIBarButtonItem!
    let formatter: DateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(YourViewController.back(sender:)))
//        self.navigationItem.leftBarButtonItem = newBackButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let nib = UINib.init(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Int(SCGPush.sharedInstance().numberOfMessages())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        
        let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row))!
        
        self.formatter.dateStyle = .medium
        self.formatter.timeStyle = .medium
        self.formatter.locale = Locale(identifier: "en_US")
        
        cell.delegate = self
        cell.labelBody.text = message.body!
        cell.labelDate.text = self.formatter.string(from: message.created)
        //debugPrint(message.created)
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 137.0;
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row)) {
            
            SCGPush.sharedInstance().loadAttachment(for: message, completionBlock: { (attachment) in
                DispatchQueue.main.async {
                    let previewQL = QLPreviewController()
                    previewQL.dataSource = self
                    previewQL.currentPreviewItemIndex = indexPath.row
                    self.navigationController?.pushViewController(previewQL, animated: true)
                }
            }, failureBlock: { (error) in
                DispatchQueue.main.async {
//                    self.showAlert("Attachment", mess: "Error loadingattachment")
                    let previewQL = QLPreviewController()
                    previewQL.dataSource = self
                    previewQL.currentPreviewItemIndex = indexPath.row
                    self.navigationController?.pushViewController(previewQL, animated: true)
                }
            })
        }
        
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let detailsViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailsViewController")
//        self.navigationController?.pushViewController(detailsViewController, animated: true)
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



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            if (SCGPush.sharedInstance().deleteMessage(at: UInt(indexPath.row))) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "logOutSegue") {
//            let destination = segue.destination as! ViewController
//            if #available(iOS 9.0, *) {
//                destination.loadViewIfNeeded()
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//    @IBAction func didPressLogOutButton(_ sender: UIBarButtonItem) {
//        
//        _ = navigationController?.popViewController(animated: true)
//    }

    // MARK: Preview
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return Int(SCGPush.sharedInstance().numberOfMessages())
    }
        
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {

        var itemUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("nopreview.txt")!
        do {
            let data = "no preview available".data(using: String.Encoding.utf8)
            if !FileManager.default.fileExists(atPath: itemUrl.absoluteString) {
                try data?.write(to: itemUrl)
            }
        } catch  {
        }

        let message: SCGPushMessage? = SCGPush.sharedInstance().message(at: UInt(index))
        
        if (message?.hasAttachment)! {
            let attachment:SCGPushAttachment? = SCGPush.sharedInstance().getAttachmentFor(message!)
            
            if (attachment != nil && (attachment?.data != nil) && (attachment?.contentType != nil)) {
                if let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent((attachment?.fileName)!) {
                    do {
                        if FileManager.default.fileExists(atPath: tempDirURL.absoluteString) {
                            try FileManager.default.removeItem(at: tempDirURL)
                        }
                        debugPrint("will try to save \(attachment?.data?.count) bytes")
                        try attachment!.data?.write(to: tempDirURL)
                        
                        itemUrl = tempDirURL
                    } catch  {
                        debugPrint("Failed to save data into item")
                    }
                }
            }
        }
        
        return itemUrl as QLPreviewItem
    }

}
