//
//  NotificationTableViewCell.swift
//  SCGPushDemo
//
//  Created by Nelko Nedelchev on 3/21/17.
//  Copyright © 2017 softavail. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var labelBody: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintLabelDateTop: NSLayoutConstraint!
    @IBOutlet weak var constraintLabelBodyBottom: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
