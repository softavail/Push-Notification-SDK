import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch?
    var labelModel: LabelModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLabel.font = UIFont.appFont(ofSize: 17)
        if let cellSwitch = self.cellSwitch {
            cellSwitch.onTintColor = .mySecondaryColor
            loadInteractionReportState()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let labelModel = self.labelModel else { return }
        
        cellLabel.text = labelModel.labelTitle
        if labelModel.settingsCellType == .labelSwitch {
            cellSwitch?.isHidden = false
        } else {
            cellSwitch?.isHidden = true
        }
    }
    
    private func loadInteractionReportState() {
        let defaults = UserDefaults.standard
        if let stateToLoad = defaults.object(forKey: "interactionReportState") as? Bool {
            cellSwitch?.isOn = stateToLoad
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        guard let cellSwitch = self.cellSwitch else { return }
        
        let defaults = UserDefaults.standard
        let stateToSave = cellSwitch.isOn
        defaults.set(stateToSave, forKey: "interactionReportState")
        defaults.synchronize()
    }
}
