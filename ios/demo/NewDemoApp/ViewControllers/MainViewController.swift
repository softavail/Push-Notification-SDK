import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.largeTitleTextAttributes = attrs
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .myPrimaryColor
        view.backgroundColor = .myPrimaryColor
        
        for case let tableView as UITableView in view.subviews {
            tableView.backgroundColor = .myPrimaryColor
            tableView.estimatedRowHeight = 44
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
    }
}
