//
//  MessageTableViewCell.swift
//  SCGPushDemo
//
//  Created by Bozhko Terziev on 28.02.24.
//  Copyright © 2024 softavail. All rights reserved.
//

import UIKit

protocol MessageTableViewCellDelegate: AnyObject {
    func didPressDeliveryButton(for cell: MessageTableViewCell)
    func didPressDeleteButton(for cell: MessageTableViewCell)
    func didPressDeepLinkButton(for cell: MessageTableViewCell)
    func didPressClickThruButton(for cell: MessageTableViewCell)
    func didPressAttachmentButton(for cell: MessageTableViewCell)
    func didPressReadButton(for cell: MessageTableViewCell)
}

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var delivery: UIButton!
    @IBOutlet weak var read: UIButton!
    @IBOutlet weak var clickThru: UIButton!
    @IBOutlet weak var attachment: UIButton!
    @IBOutlet weak var deepLink: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    weak var delegate: MessageTableViewCellDelegate?
    var messageModel: MessageModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
        title.numberOfLines = 0
        title.font = UIFont.appBoldFont(ofSize: 17.0)
        title.backgroundColor = UIColor.white
        title.textColor = UIColor.black
        title.textAlignment = .left
        
        created.numberOfLines = 1
        created.font = UIFont.appFont(ofSize: 15.0)
        created.backgroundColor = UIColor.white
        created.textColor = UIColor.darkGray
        created.textAlignment = .right
    }

    func updateCell() {
        guard let model = self.messageModel else { return }
        self.attachment.isEnabled = model.hasAttachment
        setup(button: delivery, withTitle: TITLE_DELIVERY, andColor:.buttonColorDelivery)
        setup(button: read, withTitle: TITLE_READ, andColor:.buttonColorRead)
        setup(button: clickThru, withTitle: TITLE_CLICKTHRU, andColor:.buttonColorClickThru)
        setup(button: attachment, withTitle: TITLE_ATTACHMENT, andColor:.buttonColorAttachment)
        setup(button: deepLink, withTitle: TITLE_DEEPLINK, andColor:.buttonColorDeepLink)
        setup(button: delete, withTitle: TITLE_DELETE, andColor:.buttonColorDelete)
        title.text = model.title
        created.text = model.created
    }
    
    private func setup(button:UIButton, withTitle:String, andColor:UIColor) {
        let attrsNormal: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]

        let attrSelected: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white.withAlphaComponent(0.66)
        ]

        let attrDisabled: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white.withAlphaComponent(0.66)
        ]

        let attributedButtonTitleNormal = NSAttributedString(string: withTitle, attributes: attrsNormal)
        let attributedButtonTitleSelected = NSAttributedString(string: withTitle, attributes: attrSelected)
        let attributedButtonTitleDisabled = NSAttributedString(string: withTitle, attributes: attrDisabled)
        
        button.setAttributedTitle(attributedButtonTitleNormal, for: .normal)
        button.setAttributedTitle(attributedButtonTitleDisabled, for: .disabled)
        button.setAttributedTitle(attributedButtonTitleSelected, for: .selected)
        button.setAttributedTitle(attributedButtonTitleSelected, for: .highlighted)
        
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = button.isEnabled ? andColor : andColor.withAlphaComponent(0.66)
        
        button.layer.cornerRadius = floor(button.bounds.size.height/2)
    }
    
    // MARK: - Action methods
    
    @IBAction func onDelivery(_ sender: Any) {
        delegate?.didPressDeliveryButton(for: self)
    }
    
    @IBAction func onRead(_ sender: Any) {
        delegate?.didPressReadButton(for: self)
    }
    
    @IBAction func onClickThru(_ sender: Any) {
        delegate?.didPressClickThruButton(for: self)
    }
    
    @IBAction func onAttachment(_ sender: Any) {
        delegate?.didPressAttachmentButton(for: self)
    }
    
    @IBAction func onDeepLink(_ sender: Any) {
        delegate?.didPressDeepLinkButton(for: self)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        delegate?.didPressDeleteButton(for: self)
    }
}
