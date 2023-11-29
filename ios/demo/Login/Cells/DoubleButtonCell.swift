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
        guard let doubleButtonModel = self.doubleButtonModel else { return }
        
        resetBadgeButton.setTitle(doubleButtonModel.resetBadgeButtonTitle, for: .normal)
        goToInboxButton.setTitle(doubleButtonModel.goToInboxButtonTitle, for: .normal)
    }
    
    @IBAction func goToInboxButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func resetBadgeButtonTapped(_ sender: Any) {
        
    }
}
