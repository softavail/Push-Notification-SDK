import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellDelegate {
    @IBOutlet var loginTableVIew: UITableView!
    lazy var loginDataSource = LoginViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SCGPush Test App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        dataSource = loginDataSource.getLoginDataSource()
        loginTableVIew.separatorStyle = .none
        loginTableVIew.estimatedRowHeight = 44
        loginTableVIew.rowHeight = UITableView.automaticDimension
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ButtonCell {
                cell.buttonModel = model as? ButtonModel
                cell.updateCell()
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: ButtonCellDelegate methods
    
    func didPressRegisterButton(forCell: ButtonCell) {
        guard let accessTokenModel = dataSource[LoginCellType.accessToken.rawValue] as? TextFieldModel else { return }
        guard let appIDModel = dataSource[LoginCellType.appID.rawValue] as? TextFieldModel else { return }
        
        let accessStr = accessTokenModel.textFieldValue
        let appIDStr = appIDModel.textFieldValue
        
        guard let accessStr = accessStr else { return }
        guard let appIDStr = appIDStr else { return }
        
        print(accessStr)
        print(appIDStr)
    }
    
    // MARK: adjustKeyboard method
    
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
}
