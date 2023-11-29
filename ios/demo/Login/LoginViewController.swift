import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate {
    @IBOutlet var loginTableVIew: UITableView!
    lazy var loginDataSource = LoginViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SCGPush Test App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
        dataSource = loginDataSource.getLoginDataSource()
        loginTableVIew.separatorStyle = .none
        loginTableVIew.estimatedRowHeight = 44
        loginTableVIew.rowHeight = UITableView.automaticDimension
        loginTableVIew.delaysContentTouches = false
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
                return cell
            }
        } else if model.loginCellType == .appID {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TextFieldCell {
                cell.textFieldModel = model as? TextFieldModel
                cell.updateCell()
                return cell
            }
        } else if model.loginCellType == .register {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ButtonCell {
                cell.buttonModel = model as? ButtonModel
                cell.updateCell()
                cell.delegate = self
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
    
    func didPressRegisterButton(forCell cell: ButtonCell) {
        guard let accessTokenModel = dataSource[LoginCellType.accessToken.rawValue] as? TextFieldModel else { return }
        guard let appIDModel = dataSource[LoginCellType.appID.rawValue] as? TextFieldModel else { return }
        
        cell.registerButton.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        let accessString = accessTokenModel.textFieldValue
        let appIDString = appIDModel.textFieldValue
        
        guard let accessString = accessString else { return }
        guard let appIDString = appIDString else { return }
        
        let accessStringTrimmed = accessString.trimWhiteSpaces()
        let appIDStringTrimmed = appIDString.trimWhiteSpaces()
        
        print(accessStringTrimmed)
        print(appIDStringTrimmed)
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
        
    }
}
