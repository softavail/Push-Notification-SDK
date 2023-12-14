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
        
        activityIndicator?.isHidden = true
        registerButton?.disable()
        registerButton?.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        let attrsWhite: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]
        let attrsBlack: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ]
        
        let attributedButtonTitleWhite = NSAttributedString(string: buttonTitle, attributes: attrsWhite)
        let attributedButtonTitleBlack = NSAttributedString(string: buttonTitle, attributes: attrsBlack)
        
        if previousTraitCollection?.userInterfaceStyle == .dark {
            registerButton?.backgroundColor = .black
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .normal)
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .disabled)
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .highlighted)
        } else {
            registerButton?.backgroundColor = .white
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .normal)
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .disabled)
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .highlighted)
        }
    }
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17)
        ]
        let attrsWhite: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]
        let attrsBlack: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ]
        
        let attributedButtonTitle = NSAttributedString(string: buttonTitle, attributes: attrs)
        let attributedButtonTitleWhite = NSAttributedString(string: buttonTitle, attributes: attrsWhite)
        let attributedButtonTitleBlack = NSAttributedString(string: buttonTitle, attributes: attrsBlack)
        
        if traitCollection.userInterfaceStyle == .dark {
            registerButton?.backgroundColor = .white
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .normal)
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .disabled)
            registerButton?.setAttributedTitle(attributedButtonTitleBlack, for: .highlighted)
        } else {
            registerButton?.backgroundColor = .black
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .normal)
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .disabled)
            registerButton?.setAttributedTitle(attributedButtonTitleWhite, for: .highlighted)
        }
        
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .normal)
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .disabled)
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .highlighted)
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
