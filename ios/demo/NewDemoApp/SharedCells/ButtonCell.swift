import UIKit

protocol ButtonCellDelegate {
    func didPressRegisterButton(for cell: ButtonCell)
}

class ButtonCell: UITableViewCell, LoginViewControllerDelegate {
    @IBOutlet var clipboardButton: UIButton?
    @IBOutlet var registerButton: UIButton?
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    var buttonModel: ButtonModel?
    var delegate: ButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipboardButton?.titleLabel?.font = UIFont.appFont(ofSize: 17)
        registerButton?.titleLabel?.font = UIFont.appFont(ofSize: 17)
        activityIndicator?.isHidden = true
        registerButton?.titleLabel?.numberOfLines = 2
        registerButton?.disable()
        registerButton?.setTitleColor(.gray, for: .disabled)
        registerButton?.layer.cornerRadius = 20
        
        if traitCollection.userInterfaceStyle == .dark {
            registerButton?.backgroundColor = .white
            registerButton?.setTitleColor(.black, for: .normal)
        } else {
            registerButton?.backgroundColor = .black
            registerButton?.setTitleColor(.white, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .dark {
            registerButton?.backgroundColor = .black
            registerButton?.setTitleColor(.white, for: .normal)
        } else {
            registerButton?.backgroundColor = .white
            registerButton?.setTitleColor(.black, for: .normal)
        }
    }
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        registerButton?.setTitle(buttonTitle, for: .normal)
        clipboardButton?.setTitle(buttonTitle, for: .normal)
    }
    
    func textFieldsDidChange(for viewController: LoginViewController) {
        if !viewController.accessTokenIsEmpty && !viewController.appIDIsEmpty {
            registerButton?.enable()
        } else {
            registerButton?.disable()
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        delegate?.didPressRegisterButton(for: self)
    }
    
    @IBAction func clipboardButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let tokenString = defaults.object(forKey: "apnTokenString") as? String
        UIPasteboard.general.string = tokenString ?? ""
    }
}
