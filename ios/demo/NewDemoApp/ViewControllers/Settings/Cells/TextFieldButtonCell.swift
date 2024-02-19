import UIKit

class TextFieldButtonCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    weak var parentViewController: UIViewController?
    var textFieldButtonModel: TextFieldButtonModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.font = UIFont.appFont(ofSize: 15)
        textField.clearButtonMode = .whileEditing
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let textFieldButtonModel = self.textFieldButtonModel else { return }
        guard let buttonTitle = textFieldButtonModel.buttonTitle else { return }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 17)
        ]
        let attributedButtonTitle = NSAttributedString(string: buttonTitle, attributes: attrs)
        
        saveButton.setAttributedTitle(attributedButtonTitle, for: .normal)
        saveButton.setAttributedTitle(attributedButtonTitle, for: .disabled)
        saveButton.setAttributedTitle(attributedButtonTitle, for: .highlighted)
        
        textField.text = textFieldButtonModel.textFieldValue
        textField.placeholder = textFieldButtonModel.textFieldPlaceholder
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let textFieldText = textField.text else { return }
        
        textField.resignFirstResponder()
        if textFieldText.starts(with: "http://") || textFieldText.starts(with: "https://") {
            let defaults = UserDefaults.standard
            let jsonEncoder = JSONEncoder()
            
            do {
                let textToSave = try jsonEncoder.encode(textFieldText)
                defaults.set(textToSave, forKey: "baseURL")
            } catch let error {
                print("Error in saving baseURL: \(error.localizedDescription)")
            }
        } else {
            guard let parentViewController = self.parentViewController else { return }
            
            textField.text = ""
            let ac = AlertControllerSingleton.shared
            ac.showError("Invalid URL format", presentFrom: parentViewController)
        }
    }
}
