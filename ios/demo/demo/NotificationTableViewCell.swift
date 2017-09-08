//
//  NotificationTableViewCell.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/21/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate: class {
    
    func didClickDelivery(cell:NotificationTableViewCell)
    func didClickRead(cell:NotificationTableViewCell)
    func didClickThru(cell:NotificationTableViewCell)
    func didClickDelete(cell:NotificationTableViewCell)
    func didClickDeepLink(cell:NotificationTableViewCell)
    func didClickAttachment(cell:NotificationTableViewCell)
}

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintTopSpaceToLabelDate: NSLayoutConstraint!
    @IBOutlet weak var constraintVerticalSpaceFromDateToBody: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomSpaceToLabelBody: NSLayoutConstraint!
    @IBOutlet weak var attachmentIndicatorView: UIImageView!
    
    weak var delegate:NotificationTableViewCellDelegate?
    
    var deepLink:String?

    var message: SCGPushMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        labelDate.backgroundColor = UIColor.clear
        labelDate.numberOfLines = 1
        
        labelBody.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickDelivery(_ sender: Any) {
        
        delegate?.didClickDelivery(cell: self)
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        
        delegate?.didClickDelete(cell: self)
    }
    
    @IBAction func onClickDeepLink(_ sender: Any) {
        
        delegate?.didClickDeepLink(cell: self)
    }
    
    @IBAction func onClickThru(_ sender: Any) {
        
        delegate?.didClickThru(cell: self)
    }
    
    @IBAction func onClickRead(_ sender: Any) {
        
        delegate?.didClickRead(cell: self)
    }

    @IBAction func onClickAttachment(_ sender: Any) {
        
        delegate?.didClickAttachment(cell: self)
    }
}
