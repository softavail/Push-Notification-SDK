import UIKit

class DoubleButtonCell: UITableViewCell {
    @IBOutlet var resetBadgeButton: UIButton!
    @IBOutlet var goToInboxButton: UIButton!
    var doubleButtonModel: DoubleButtonModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let leftButtonTitle = doubleButtonModel?.leftButtonTitle else { return }
        guard let rightButtonTitle = doubleButtonModel?.rightButtonTitle else { return }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 15)
        ]
        let attributedLeftButtonTitle = NSAttributedString(string: leftButtonTitle, attributes: attrs)
        let attributedRightButtonTitle = NSAttributedString(string: rightButtonTitle, attributes: attrs)
        
        goToInboxButton.setAttributedTitle(attributedLeftButtonTitle, for: .normal)
        goToInboxButton.setAttributedTitle(attributedLeftButtonTitle, for: .disabled)
        goToInboxButton.setAttributedTitle(attributedLeftButtonTitle, for: .highlighted)
        resetBadgeButton.setAttributedTitle(attributedRightButtonTitle, for: .normal)
        resetBadgeButton.setAttributedTitle(attributedRightButtonTitle, for: .disabled)
        resetBadgeButton.setAttributedTitle(attributedRightButtonTitle, for: .highlighted)
    }
    
    @IBAction func goToInboxButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func resetBadgeButtonTapped(_ sender: Any) {
        
    }
}
