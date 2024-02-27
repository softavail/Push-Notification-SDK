import UIKit
import SCGPushSDK

protocol LoginViewControllerDelegate: AnyObject {
    func textFieldsDidChange(for viewController: LoginViewController)
}

class LoginViewController: MainViewController, UITableViewDelegate, UITableViewDataSource, RegisterButtonCellDelegate, TextFieldCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    lazy var loginDataSource = LoginViewControllerData()
    weak var delegate: LoginViewControllerDelegate?
    var dataSource = [BaseModel]()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: SETTINGS, style: .plain, target: self, action: #selector(settingsTapped))
        var token = ""
        var appId = ""

        if let accessTokenData = UserDefaults.standard.data(forKey: "accessToken") {
            do {
                token = try JSONDecoder().decode(String.self, from: accessTokenData)
            } catch {
                print("Error: Cant decode token")
            }
        }
        if let appIdData = UserDefaults.standard.data(forKey: "appID") {
            do {
                appId = try JSONDecoder().decode(String.self, from: appIdData)
            } catch {
                print("Error: Cant decode appId")
            }
        }

        dataSource = loginDataSource.getLoginDataSource(token: token, appId: appId)
        tableView.delaysContentTouches = false
        
        
    }
    
    // MARK: - #selector methods
    
    @objc private func settingsTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewSettingsViewController") as? NewSettingsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RegisterButtonCell {
                cell.buttonModel = model as? ButtonModel
                cell.updateCell()
                cell.delegate = self
                delegate = cell
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
    
    // MARK: - RegisterButtonCellDelegate methods
    
    func didPressRegisterButton(for cell: RegisterButtonCell) {
        guard let accessTokenModel = dataSource[LoginCellType.accessToken.rawValue] as? TextFieldModel else { return }
        guard let appIDModel = dataSource[LoginCellType.appID.rawValue] as? TextFieldModel else { return }
        guard let accessTokenString = accessTokenModel.textFieldValue else { return }
        guard let appIDString = appIDModel.textFieldValue else { return }
        guard let deviceToken = SharedMethods.getDeviceToken() else { return }
        
        startBuffering(cell: cell)
        
        let baseURL = SharedMethods.getBaseURL()
        let accessTokenStringTrimmed = accessTokenString.trimWhiteSpaces()
        let appIDStringTrimmed = appIDString.trimWhiteSpaces()
        
        print(accessTokenStringTrimmed)
        print(appIDStringTrimmed)
        
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        do {
            let textToSave = try jsonEncoder.encode(accessTokenStringTrimmed)
            defaults.set(textToSave, forKey: "accessToken")
        } catch let error {
            print("Error in saving accessToken: \(error.localizedDescription)")
        }
        do {
            let textToSave = try jsonEncoder.encode(appIDStringTrimmed)
            defaults.set(textToSave, forKey: "appID")
        } catch let error {
            print("Error in saving appID: \(error.localizedDescription)")
        }
        
        defaults.synchronize()
        
        let ac = AlertControllerSingleton.shared
        SCGPush.start(withAccessToken: accessTokenStringTrimmed, appId: appIDStringTrimmed, callbackUri: baseURL, delegate: nil)
        SCGPush.sharedInstance().registerToken(deviceToken) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.stopBuffering(cell: cell)

                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesTableViewController") as? MessagesTableViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } failureBlock: { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.stopBuffering(cell: cell)
                ac.showError("Failed to register device's token: \(error?.localizedDescription ?? "")", presentFrom: self)
            }
        }
    }
    
    // MARK: - TextFieldCellDelegate methods
    
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
    
    // MARK: - Keyboard method
    
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
    
    // MARK: - Helping methods
    
    private func startBuffering(cell: RegisterButtonCell) {
        cell.registerButton.disable()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
    }
    
    private func stopBuffering(cell: RegisterButtonCell) {
        cell.registerButton.enable()
        navigationController?.navigationBar.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        cell.activityIndicator.stopAnimating()
        cell.activityIndicator.isHidden = true
    }
}

extension LoginViewController: SCGPushDelegate {
    
    func resolveTrackedLinkHasNotRedirect(_ request: URLRequest!) {
        
    }
    
    func resolveTrackedLinkDidSuccess(_ redirectLocation: String!, withrequest request: URLRequest!) {
    
    }
}
