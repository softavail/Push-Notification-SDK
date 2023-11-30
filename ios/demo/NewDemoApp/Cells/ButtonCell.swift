import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet var clipboardButton: UIButton!
    var buttonModel: ButtonModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let buttonTitle = self.buttonModel?.buttonTitle else { return }
        
        clipboardButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func clipboardButtonTapped(_ sender: Any) {
        
    }
}
