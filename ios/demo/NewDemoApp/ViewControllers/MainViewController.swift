import UIKit

class MainViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .myPrimaryColor
        view.backgroundColor = .myPrimaryColor
        
        for case let tableView as UITableView in view.subviews {
            tableView.backgroundColor = .myPrimaryColor
            tableView.estimatedRowHeight = 44
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .separatorColor
            tableView.layoutMargins = UIEdgeInsets.zero
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //notificationCenter.removeObserver(self)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
    }
}
