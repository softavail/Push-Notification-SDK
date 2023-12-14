import UIKit

class DoubleButtonCell: UITableViewCell {
    @IBOutlet var resetBadgeButton: UIButton!
    @IBOutlet var goToInboxButton: UIButton!
    var doubleButtonModel: DoubleButtonModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetBadgeButton?.titleLabel?.font = UIFont.appFont(ofSize: 17)
        goToInboxButton?.titleLabel?.font = UIFont.appFont(ofSize: 17)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let leftButtonTitle = doubleButtonModel?.leftButtonTitle else { return }
        guard let rightButtonTitle = doubleButtonModel?.rightButtonTitle else { return }
        
        goToInboxButton.setTitle(leftButtonTitle, for: .normal)
        resetBadgeButton.setTitle(rightButtonTitle, for: .normal)
    }
    
    @IBAction func goToInboxButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func resetBadgeButtonTapped(_ sender: Any) {
        
    }
}
