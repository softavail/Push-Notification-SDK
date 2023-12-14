import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellSwitch: UISwitch!
    var labelModel: LabelModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLabel.font = appFont(ofSize: 17)
        cellSwitch?.onTintColor = .mySecondaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let labelModel = self.labelModel else { return }
        
        cellLabel.text = labelModel.labelTitle
        if labelModel.settingsCellType == .labelSwitch {
            cellSwitch.isHidden = false
        } else {
            cellSwitch.isHidden = true
        }
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        
    }
}
