import UIKit

protocol ButtonCellDelegate {
    func didPressRegisterButton(forCell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    @IBOutlet var registerButton: BetterButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var buttonModel: ButtonModel?
    var delegate: ButtonCellDelegate?
    var accessTokenIsEmpty = true
    var appIDIsEmpty = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerButton.isEnabled = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleButtonDisabling), name: accessTokenIsEmptyName, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleButtonDisabling), name: accessTokenIsNotEmptyName, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleButtonDisabling), name: appIDIsEmptyName, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleButtonDisabling), name: appIDIsNotEmptyName, object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .dark {
            registerButton.setBackgroundColor(.black)
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            registerButton.setBackgroundColor(.white)
            registerButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func handleButtonDisabling(notification: Notification) {
        if notification.name == accessTokenIsEmptyName {
            accessTokenIsEmpty = true
        } else if notification.name == accessTokenIsNotEmptyName {
            accessTokenIsEmpty = false
        } else if notification.name == appIDIsEmptyName {
            appIDIsEmpty = true
        } else if notification.name == appIDIsNotEmptyName {
            appIDIsEmpty = false
        }
        
        if !appIDIsEmpty && !accessTokenIsEmpty {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    func updateCell() {
        guard let buttonModel = self.buttonModel else { return }
        
        registerButton.setTitle(buttonModel.buttonTitle, for: .normal)
        activityIndicator.isHidden = true
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.didPressRegisterButton(forCell: self)
        }
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
}
