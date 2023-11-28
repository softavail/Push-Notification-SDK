import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    var textFieldModel: TextFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let textFieldModel = textFieldModel else { return }
        
        titleLabel.text = textFieldModel.labelTitle
        textField.text = textFieldModel.textFieldValue
        textField.placeholder = textFieldModel.textFieldPlaceholder
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldModel?.textFieldValue = textField.text
    }
}
