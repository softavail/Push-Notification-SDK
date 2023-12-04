import UIKit

class NewSettingsViewControllerData: NSObject {
    func getSettingsDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let baseURL = TextFieldModel()
        baseURL.textFieldValue = ""
        baseURL.textFieldPlaceholder = "Base URL"
        baseURL.settingsCellType = .baseURL
        baseURL.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(baseURL)
        
        let labelSwitch = LabelModel()
        labelSwitch.labelTitle = "Interaction Report - on/off"
        labelSwitch.settingsCellType = .labelSwitch
        labelSwitch.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(labelSwitch)
        
        let deviceToken = LabelModel()
        deviceToken.labelTitle = "Device's Token"
        deviceToken.settingsCellType = .deviceToken
        deviceToken.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(deviceToken)
        
        let tokenLabel = LabelModel()
        tokenLabel.labelTitle = getDeviceTokenString() ?? "Token Label"
        tokenLabel.settingsCellType = .tokenLabel
        tokenLabel.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(tokenLabel)
        
        let clipboard = ButtonModel()
        clipboard.buttonTitle = "Copy to Clipboard"
        clipboard.settingsCellType = .clipboard
        clipboard.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(clipboard)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
    
    func getDeviceTokenString() -> String? {
        let defaults = UserDefaults.standard
        
        let tokenString = defaults.object(forKey: "apnTokenString") as? String
        return tokenString
    }
}
