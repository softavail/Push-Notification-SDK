import UIKit

protocol LoginViewControllerDelegate {
    func textFieldsDidChange(for viewController: LoginViewController)
}

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate, TextFieldCellDelegate {
    @IBOutlet var loginTableVIew: UITableView!
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
        
        title = "SCGPush Test App"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        dataSource = loginDataSource.getLoginDataSource()
        loginTableVIew.separatorStyle = .none
        loginTableVIew.estimatedRowHeight = 44
        loginTableVIew.rowHeight = UITableView.automaticDimension
        loginTableVIew.delaysContentTouches = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    // MARK: UITableView methods
    
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RegisterButtonCell {
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
    
    func didPressRegisterButton(for cell: RegisterButtonCell) {
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
        
        cell.registerButton.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoggedViewController") as? LoggedViewController {
            cell.registerButton.isEnabled = true
            navigationController?.navigationBar.isUserInteractionEnabled = true
            view.isUserInteractionEnabled = true
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            
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
    
    // MARK: #selector methods
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            loginTableVIew.contentInset = .zero
        } else {
            loginTableVIew.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        loginTableVIew.scrollIndicatorInsets = loginTableVIew.contentInset
    }
    
    @objc func settingsTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewSettingsViewController") as? NewSettingsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
