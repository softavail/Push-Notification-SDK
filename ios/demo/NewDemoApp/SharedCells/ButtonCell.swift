import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet weak var clipboardButton: UIButton?
    @IBOutlet weak var resetBadgeButton: UIButton?
    var buttonModel: ButtonModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17)
        ]
        let attributedButtonTitle = NSAttributedString(string: buttonTitle, attributes: attrs)
        
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .normal)
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .disabled)
        clipboardButton?.setAttributedTitle(attributedButtonTitle, for: .highlighted)
        
        resetBadgeButton?.setAttributedTitle(attributedButtonTitle, for: .normal)
        resetBadgeButton?.setAttributedTitle(attributedButtonTitle, for: .disabled)
        resetBadgeButton?.setAttributedTitle(attributedButtonTitle, for: .highlighted)
    }
    
    @IBAction func clipboardButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let tokenString = defaults.object(forKey: "apnTokenString") as? String
        UIPasteboard.general.string = tokenString ?? ""
    }
    
    @IBAction func resetBadgeButtonTapped(_ sender: Any) {
        
    }
}
