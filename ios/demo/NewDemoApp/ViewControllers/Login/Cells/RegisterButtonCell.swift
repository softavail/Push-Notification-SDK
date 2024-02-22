import UIKit

protocol RegisterButtonCellDelegate {
    func didPressRegisterButton(for cell: RegisterButtonCell)
}

class RegisterButtonCell: UITableViewCell, LoginViewControllerDelegate {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var buttonModel: ButtonModel?
    var delegate: RegisterButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.isHidden = true
        registerButton.disable()
        registerButton.layer.cornerRadius = 15
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
        let attrsGray: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.gray
        ]
        
        let attributedButtonTitleWhite = NSAttributedString(string: buttonTitle, attributes: attrsWhite)
        let attributedButtonTitleBlack = NSAttributedString(string: buttonTitle, attributes: attrsBlack)
        let attributedButtonTitleGray = NSAttributedString(string: buttonTitle, attributes: attrsGray)
        
        if previousTraitCollection?.userInterfaceStyle == .dark {
            registerButton.backgroundColor = .black
            registerButton.setAttributedTitle(attributedButtonTitleWhite, for: .normal)
            registerButton.setAttributedTitle(attributedButtonTitleGray, for: .disabled)
            registerButton.setAttributedTitle(attributedButtonTitleWhite, for: .highlighted)
        } else {
            registerButton.backgroundColor = .white
            registerButton.setAttributedTitle(attributedButtonTitleBlack, for: .normal)
            registerButton.setAttributedTitle(attributedButtonTitleGray, for: .disabled)
            registerButton.setAttributedTitle(attributedButtonTitleBlack, for: .highlighted)
        }
    }
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        let attrsWhite: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]
        let attrsBlack: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ]
        let attrsGray: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.gray
        ]
        
        let attributedButtonTitleWhite = NSAttributedString(string: buttonTitle, attributes: attrsWhite)
        let attributedButtonTitleBlack = NSAttributedString(string: buttonTitle, attributes: attrsBlack)
        let attributedButtonTitleGray = NSAttributedString(string: buttonTitle, attributes: attrsGray)
        
        if traitCollection.userInterfaceStyle == .dark {
            registerButton.backgroundColor = .white
            registerButton.setAttributedTitle(attributedButtonTitleBlack, for: .normal)
            registerButton.setAttributedTitle(attributedButtonTitleGray, for: .disabled)
            registerButton.setAttributedTitle(attributedButtonTitleBlack, for: .highlighted)
        } else {
            registerButton.backgroundColor = .black
            registerButton.setAttributedTitle(attributedButtonTitleWhite, for: .normal)
            registerButton.setAttributedTitle(attributedButtonTitleGray, for: .disabled)
            registerButton.setAttributedTitle(attributedButtonTitleWhite, for: .highlighted)
        }
    }
    
    func textFieldsDidChange(for viewController: LoginViewController) {
        if !viewController.accessTokenIsEmpty && !viewController.appIDIsEmpty {
            registerButton.enable()
        } else {
            registerButton.disable()
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        delegate?.didPressRegisterButton(for: self)
    }
}
