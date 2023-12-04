import UIKit
import UserNotifications

protocol LoginViewControllerDelegate {
    func textFieldsDidChange(for viewController: LoginViewController)
}

class LoginViewController: MainViewController, UITableViewDelegate, UITableViewDataSource,  UNUserNotificationCenterDelegate, ButtonCellDelegate, TextFieldCellDelegate {
    @IBOutlet var loginTableView: UITableView!
    lazy var loginDataSource = LoginViewControllerData()
    var dataSource = [BaseModel]()
    var delegate: LoginViewControllerDelegate?
    var accessTokenIsEmpty = true {
        didSet {
            delegate?.textFieldsDidChange(for: self)
        }
    }
    var appIDIsEmpty = true {
        didSet {
            delegate?.textFieldsDidChange(for: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SCGPush Demo App"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        dataSource = loginDataSource.getLoginDataSource()
        loginTableView.delaysContentTouches = false
    }
    
    // MARK: #selector methods
    
    @objc func settingsTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewSettingsViewController") as? NewSettingsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        guard let cellIdentifier = model.cellIdentifier else { return UITableViewCell() }
        
        if model.loginCellType == .accessToken {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextFieldCell {
                cell.textFieldModel = model as? TextFieldModel
                cell.updateCell()
                cell.delegate = self
                return cell
            }
        } else if model.loginCellType == .appID {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextFieldCell {
                cell.textFieldModel = model as? TextFieldModel
                cell.updateCell()
                cell.delegate = self
                return cell
            }
        } else if model.loginCellType == .register {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ButtonCell {
                cell.buttonModel = model as? ButtonModel
                cell.updateCell()
                cell.delegate = self
                delegate = cell
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DoubleButtonCell {
                cell.doubleButtonModel = model as? DoubleButtonModel
                cell.updateCell()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: ButtonCellDelegate methods
    
    func didPressRegisterButton(for cell: ButtonCell) {
        guard let accessTokenModel = dataSource[LoginCellType.accessToken.rawValue] as? TextFieldModel else { return }
        guard let appIDModel = dataSource[LoginCellType.appID.rawValue] as? TextFieldModel else { return }
        
        let accessString = accessTokenModel.textFieldValue
        let appIDString = appIDModel.textFieldValue
        
        guard let accessString = accessString else { return }
        guard let appIDString = appIDString else { return }
        
        let accessStringTrimmed = accessString.trimWhiteSpaces()
        let appIDStringTrimmed = appIDString.trimWhiteSpaces()
        
        print(accessStringTrimmed)
        print(appIDStringTrimmed)
        
        cell.registerButton?.disable()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        cell.activityIndicator?.isHidden = false
        cell.activityIndicator?.startAnimating()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoggedViewController") as? LoggedViewController {
            cell.registerButton?.enable()
            navigationController?.navigationBar.isUserInteractionEnabled = true
            view.isUserInteractionEnabled = true
            cell.activityIndicator?.stopAnimating()
            cell.activityIndicator?.isHidden = true
            
            present(vc, animated: true)
        }
    }
    
    // MARK: TextFieldCellDelegate methods
    
    func textFieldDidChange(for cell: TextFieldCell) {
        guard let text = cell.textField.text else { return }
        
        if cell.textFieldModel?.loginCellType == .accessToken {
            if text.isEmpty {
                accessTokenIsEmpty = true
            } else {
                accessTokenIsEmpty = false
            }
        } else if cell.textFieldModel?.loginCellType == .appID {
            if text.isEmpty {
                appIDIsEmpty = true
            } else {
                appIDIsEmpty = false
            }
        }
    }
    
    // MARK: Keyboard method
    
    override func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            loginTableView.contentInset = .zero
        } else {
            loginTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        loginTableView.scrollIndicatorInsets = loginTableView.contentInset
    }
    
    // MARK: UNUserNotificationCenter methods
    
    func registerNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
            if success {
                print("Notification request granted.")
            } else {
                print("Notification request NOT granted.")
            }
        }
    }
    
    func scheduleNotifications() {
        guard let notificationImageURL = getNotificationImageURL() else { return }
        guard let notificationImage = try? UNNotificationAttachment(identifier: UUID().uuidString, url: notificationImageURL) else { return }
        
        let center = UNUserNotificationCenter.current()
        registerNotificationCategories()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.sound = .default
        content.categoryIdentifier = "categoryIdentifier"
        content.userInfo = ["UserInfoKey": "UserInfoData"]
        content.attachments = [notificationImage]
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let action1 = UNNotificationAction(identifier: "action1", title: "Action1", options: .foreground)
        let action2 = UNNotificationAction(identifier: "action2", title: "Action2", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "categoryIdentifier", actions: [action1, action2], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func getNotificationImageURL() -> URL? {
        return Bundle.main.url(forResource: "notificationImage", withExtension: "png")
    }
    
    // MARK: UNUserNotificationCenterDelegate methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let userInfoData = userInfo["UserInfoKey"] as? String {
            print(userInfoData)
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            break
        case "action1":
            break
        case "action2":
            break
        default:
            break
        }
        
        completionHandler()
    }
}
