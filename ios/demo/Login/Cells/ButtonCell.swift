import UIKit

protocol ButtonCellDelegate {
    func didPressRegisterButton(forCell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    @IBOutlet var registerButton: UIButton!
    var buttonModel: ButtonModel?
    var delegate: ButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if traitCollection.userInterfaceStyle != .dark {
            registerButton.backgroundColor = .black
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            registerButton.backgroundColor = .white
            registerButton.setTitleColor(.black, for: .normal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .dark {
            registerButton.backgroundColor = .black
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            registerButton.backgroundColor = .white
            registerButton.setTitleColor(.black, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let buttonModel = buttonModel else { return }
        
        registerButton.setTitle(buttonModel.buttonTitle, for: .normal)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.didPressRegisterButton(forCell: self)
        }
    }
}
