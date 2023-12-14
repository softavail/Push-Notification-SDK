import UIKit

protocol TextFieldCellDelegate {
    func textFieldDidChange(for cell: TextFieldCell)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var titleLabel: UILabel?
    var textFieldModel: TextFieldModel?
    var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.font = appFont(ofSize: 15)
        titleLabel?.font = appFont(ofSize: 14)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let textFieldModel = self.textFieldModel else { return }
        
        titleLabel?.text = textFieldModel.labelTitle
        textField.text = textFieldModel.textFieldValue
        textField.placeholder = textFieldModel.textFieldPlaceholder
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldModel?.textFieldValue = textField.text
        delegate?.textFieldDidChange(for: self)
    }
}
