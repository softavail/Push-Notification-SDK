import UIKit

class NewSettingsViewController: MainViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    lazy var settingsDataSource = NewSettingsViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(notificationsTapped))
        
        dataSource = settingsDataSource.getSettingsDataSource()
        tableView.delaysContentTouches = false
    }
    
    // MARK: #selector methods
    
    @objc func notificationsTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
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
        
        if model.settingsCellType == .baseURL {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextFieldCell {
                cell.textFieldModel = model as? TextFieldModel
                cell.updateCell()
                return cell
            }
        } else if model.settingsCellType == .labelSwitch {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelCell {
                cell.labelModel = model as? LabelModel
                cell.updateCell()
                return cell
            }
        } else if model.settingsCellType == .deviceToken {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelCell {
                cell.labelModel = model as? LabelModel
                cell.updateCell()
                return cell
            }
        } else if model.settingsCellType == .tokenLabel {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelCell {
                cell.labelModel = model as? LabelModel
                cell.updateCell()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ButtonCell {
                cell.buttonModel = model as? ButtonModel
                cell.updateCell()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: Keyboard method
    
    override func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}
