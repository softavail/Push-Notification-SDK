//
//  NotificationTableViewCell.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/21/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate: class {
    
    func didClickDelivery(cell:UITableViewCell)
    func didClickRead(cell:UITableViewCell)
    func didClickThru(cell:UITableViewCell)
    func didClickDelete(cell:UITableViewCell)
    func didClickDeepLink(cell:UITableViewCell)
    func didClickAttachment(cell:UITableViewCell)
}

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonDelivery: UIButton!
    @IBOutlet weak var buttonRead: UIButton!
    @IBOutlet weak var buttonThru: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonDeepLink: UIButton!
    @IBOutlet weak var buttonAttachment: UIButton!
    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintLabelDateTop: NSLayoutConstraint!
    
    weak var delegate:NotificationTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonDelivery.layer.cornerRadius = 5;
        buttonDelivery.layer.masksToBounds = true;
        buttonDelivery.layer.borderColor = UIColor.blue.cgColor;
        buttonDelivery.layer.borderWidth = 0.5;

        buttonAttachment.layer.cornerRadius = 5;
        buttonAttachment.layer.masksToBounds = true;
        buttonAttachment.layer.borderColor = UIColor.blue.cgColor;
        buttonAttachment.layer.borderWidth = 0.5;

        buttonDeepLink.layer.cornerRadius = 5;
        buttonDeepLink.layer.masksToBounds = true;
        buttonDeepLink.layer.borderColor = UIColor.blue.cgColor;
        buttonDeepLink.layer.borderWidth = 0.5;

        buttonDelete.layer.cornerRadius = 5;
        buttonDelete.layer.masksToBounds = true;
        buttonDelete.layer.borderColor = UIColor.blue.cgColor;
        buttonDelete.layer.borderWidth = 0.5;

        buttonThru.layer.cornerRadius = 5;
        buttonThru.layer.masksToBounds = true;
        buttonThru.layer.borderColor = UIColor.blue.cgColor;
        buttonThru.layer.borderWidth = 0.5;

        buttonRead.layer.cornerRadius = 5;
        buttonRead.layer.masksToBounds = true;
        buttonRead.layer.borderColor = UIColor.blue.cgColor;
        buttonRead.layer.borderWidth = 0.5;

        // Initialization code
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
