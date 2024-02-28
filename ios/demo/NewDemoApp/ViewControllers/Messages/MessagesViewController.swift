//
//  MessagesViewController.swift
//  SCGPushDemo
//
//  Created by Bozhko Terziev on 27.02.24.
//  Copyright © 2024 softavail. All rights reserved.
//

import UIKit

class MessagesViewController: MainViewController, UITableViewDelegate, UITableViewDataSource, MessageTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    lazy var messagesDataSource = MessagesViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = TITLE_MESSAGES
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)

        let nib = UINib.init(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
        
        dataSource = messagesDataSource.getMessagesDataSource()
        tableView.delaysContentTouches = false
    }
    

    // MARK: - UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        guard let cellIdentifier = model.cellIdentifier else { return UITableViewCell() }
        
        if model.messagesCellType == .buttons {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell {
                cell.messageModel = model as? MessageModel
                cell.updateCell()
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: - MessageTableViewCellDelegate methods
    
    func didPressDeliveryButton(for cell: MessageTableViewCell) {
    }
    
    func didPressDeleteButton(for cell: MessageTableViewCell) {
    }
    
    func didPressDeepLinkButton(for cell: MessageTableViewCell) {
    }
    
    func didPressClickThruButton(for cell: MessageTableViewCell) {
    }
    
    func didPressAttachmentButton(for cell: MessageTableViewCell) {
    }
    
    func didPressReadButton(for cell: MessageTableViewCell) {
    }
}
