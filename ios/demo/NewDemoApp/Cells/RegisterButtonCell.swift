import UIKit

protocol ButtonCellDelegate {
    func didPressRegisterButton(for cell: RegisterButtonCell)
}

class RegisterButtonCell: UITableViewCell, LoginViewControllerDelegate {
    @IBOutlet var registerButton: BetterButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var buttonModel: ButtonModel?
    var delegate: ButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.isHidden = true
        registerButton.isEnabled = false
        registerButton.titleLabel?.numberOfLines = 2
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
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        registerButton.setTitle(buttonTitle, for: .normal)
    }
    
    func textFieldsDidChange(for viewController: LoginViewController) {
        if !viewController.accessTokenIsEmpty && !viewController.appIDIsEmpty {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        delegate?.didPressRegisterButton(for: self)
    }
}
