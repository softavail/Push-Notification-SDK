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
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
        initMe()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initMe()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMe()
    }
    
    func initMe() {
        self.todayFormatter.dateStyle = .none
        self.todayFormatter.timeStyle = .short
        self.todayFormatter.locale = Locale.current

        self.lastWeekFormatter.locale = Locale.current
        self.lastWeekFormatter.dateFormat = "EEEE"

        self.formatter.dateStyle = .short
        self.formatter.timeStyle = .none
        self.formatter.locale = Locale.current
    }
    
    func didClickDelivery(cell: NotificationTableViewCell) {
        
    }
    
    func didClickRead(cell:NotificationTableViewCell) {
        
    }
    
    func didClickThru(cell:NotificationTableViewCell) {
        
    }
    
    func didClickDelete(cell:NotificationTableViewCell) {
        
    }
    
    func didClickDeepLink(cell:NotificationTableViewCell) {
     
        let url = URL(string:cell.deepLink!)
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    func didClickAttachment(cell:NotificationTableViewCell) {
        
    }

    let formatter: DateFormatter = DateFormatter()
    let todayFormatter: DateFormatter = DateFormatter()
    let lastWeekFormatter: DateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        navigationItem.largeTitleDisplayMode = .never

        let nib = UINib.init(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private helpers
    func calculateHeightWith(_ text: String, font:UIFont, maxWidth width: CGFloat) -> CGFloat {
        let size: CGSize =
        text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font: font], context: nil).size as CGSize
        
        return size.height
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(SCGPush.sharedInstance().numberOfMessages())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        
        let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row))!
        
        cell.delegate = self
        cell.message = message
        cell.labelBody.text = message.body!

        cell.deepLink = message.deepLink;
        //debugPrint(message.created)
        
        // Configure the cell...

    
        if Calendar.current.isDateInToday(message.created) {
            cell.labelDate.text = self.todayFormatter.string(from: message.created)
        } else if (Date().timeIntervalSince(message.created) < (7 * 24 * 3600)) {
            cell.labelDate.text = self.lastWeekFormatter.string(from: message.created)
        } else {
            cell.labelDate.text = self.formatter.string(from: message.created)
        }

        if message.hasAttachment {
            cell.attachmentButton.isHidden = false;
        } else {
            cell.attachmentButton.isHidden = true;
        }
        
        debugPrint("cell date: \(cell.labelDate.text!)")
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row))!
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell
        let totalVerticalMargins:CGFloat =
            cell.constraintTopSpaceToLabelDate.constant +
            cell.constraintVerticalSpaceBodyToDelivery.constant +
            cell.constraintVertialSpaceClickToDelete.constant
        
        let labelDateWidth: CGFloat = cell.labelDate.intrinsicContentSize.width
        let labelBodyHeight: CGFloat = calculateHeightWith(message.body!, font: cell.labelBody.font, maxWidth: self.tableView.bounds.size.width - labelDateWidth)
        let attachmentButtonHeight = cell.attachmentButton.intrinsicContentSize.height;
        let deliveryButtonHeight = cell.deliveryButton.intrinsicContentSize.height;
        let calculatedHeight = totalVerticalMargins + labelBodyHeight + attachmentButtonHeight + deliveryButtonHeight + 10;
        
        return [75, calculatedHeight].max()!
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row)) {
            
            if message.hasAttachment {
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
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let detailsViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailsViewController")
//        self.navigationController?.pushViewController(detailsViewController, animated: true)
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



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            if (SCGPush.sharedInstance().deleteMessage(at: UInt(indexPath.row))) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(indexPath.row))!
        let array: NSMutableArray = NSMutableArray()
        

        // delete action
        let actionDelete:UITableViewRowAction = UITableViewRowAction.init(
            style: UITableViewRowAction.Style.destructive,
            title: "Delete",
            handler: { (action, indexPath) in
                // Delete the row from the data source
                if (SCGPush.sharedInstance().deleteMessage(at: UInt(indexPath.row))) {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
        })
        //actionDelete.backgroundColor = UIColor.blue
        array.add(actionDelete)

        // read action
        let actionRead:UITableViewRowAction = UITableViewRowAction.init(
            style: UITableViewRowAction.Style.default,
            title: "Read",
            handler: { (action, indexPath) in
                SCGPush.sharedInstance().reportStatus(withMessageId: message.identifier,
                                                      andMessageState: MessageState.read,
                                                      completionBlock: {
                }, failureBlock: { (error) in
                })

                tableView.setEditing(false, animated: true)
        })
        actionRead.backgroundColor = UIColor.blue
        array.add(actionRead)

        // click trough action
        let actionClickTrough:UITableViewRowAction = UITableViewRowAction.init(
            style: UITableViewRowAction.Style.default,
            title: "Click",
            handler: { (action, indexPath) in
                SCGPush.sharedInstance().reportStatus(withMessageId: message.identifier,
                                                      andMessageState: MessageState.clicked,
                                                      completionBlock: {
                }, failureBlock: { (error) in
                })
                
                tableView.setEditing(false, animated: true)
        })
        actionClickTrough.backgroundColor = UIColor.lightGray
        array.add(actionClickTrough)

        if let url:String = message.deepLink {
            if (url.lengthOfBytes(using: String.Encoding.utf8) > 0) {
                let actionDeepLink:UITableViewRowAction = UITableViewRowAction.init(
                    style: UITableViewRowAction.Style.default,
                    title: "Link",
                    handler: { (action, indexPath) in
                        SCGPush.sharedInstance().resolveTrackedLink(message.deepLink)
                        tableView.setEditing(false, animated: true)
                })
                
                actionDeepLink.backgroundColor = UIColor.orange
                array.add(actionDeepLink)
            }
        }
        
        return array as? [UITableViewRowAction]
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
                        debugPrint("will try to save \(attachment?.data?.count ?? 0) bytes")
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
