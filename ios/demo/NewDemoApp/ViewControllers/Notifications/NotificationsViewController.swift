import UIKit

class NotificationsViewController: MainViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    lazy var notificationsDataSource = NotificationsViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsDataSource.getNotificationsDataSource() { [weak self] dataArray in
            self?.dataSource = dataArray
        }
        tableView.separatorStyle = .singleLine
    }
    
    // MARK: UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        guard let cellIdentifier = model.cellIdentifier else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationCell {
            cell.notificationModel = model as? NotificationModel
            cell.updateCell()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AttachmentViewController") as? AttachmentViewController {
            guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else { return }
            guard let contentURL = cell.contentURL else { return }
            
            vc.selectedContentURL = cell.contentURL
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
