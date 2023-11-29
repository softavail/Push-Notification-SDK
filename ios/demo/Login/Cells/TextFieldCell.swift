import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var clearTextFieldButton: ClearTextFieldButton!
    var textFieldModel: TextFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let textFieldModel = self.textFieldModel else { return }
        
        titleLabel.text = textFieldModel.labelTitle
        textField.text = textFieldModel.textFieldValue
        textField.placeholder = textFieldModel.textFieldPlaceholder
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        textFieldModel?.textFieldValue = text
        let notificationCenter = NotificationCenter.default
        
        if textFieldModel?.loginCellType == .accessToken {
            if text.isEmpty {
                clearTextFieldButton.isHidden = true
                notificationCenter.post(name: accessTokenIsEmptyName, object: nil)
            } else {
                clearTextFieldButton.isHidden = false
                notificationCenter.post(name: accessTokenIsNotEmptyName, object: nil)
            }
        } else {
            if text.isEmpty {
                clearTextFieldButton.isHidden = true
                notificationCenter.post(name: appIDIsEmptyName, object: nil)
            } else {
                clearTextFieldButton.isHidden = false
                notificationCenter.post(name: appIDIsNotEmptyName, object: nil)
            }
        }
    }
    
    @IBAction func clearTextFieldButtonTapped(_ sender: Any) {
        textField.text = ""
        let notificationCenter = NotificationCenter.default
        
        if textFieldModel?.loginCellType == .accessToken {
            clearTextFieldButton.isHidden = true
            notificationCenter.post(name: accessTokenIsEmptyName, object: nil)
        } else {
            clearTextFieldButton.isHidden = true
            notificationCenter.post(name: appIDIsEmptyName, object: nil)
        }
    }
}
