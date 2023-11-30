import UIKit

class TripleLabelCell: UITableViewCell {
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLeftLabel: UILabel!
    @IBOutlet var bottomRightLabel: UILabel!
    var tripleLabelModel: TripleLabelModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let tripleLabelModel = self.tripleLabelModel else { return }
        
        topLabel.text = tripleLabelModel.topLabelTitle
        bottomLeftLabel.text = tripleLabelModel.bottomLeftLabelTitle
        bottomRightLabel.text = tripleLabelModel.bottomRightLabelTitle
    }
}
