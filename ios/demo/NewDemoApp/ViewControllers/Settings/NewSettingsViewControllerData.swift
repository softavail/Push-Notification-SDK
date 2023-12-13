import UIKit

class NewSettingsViewControllerData: NSObject {
    func getSettingsDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let baseURL = TextFieldModel()
        baseURL.textFieldValue = ""
        baseURL.textFieldPlaceholder = BASE_URL
        baseURL.settingsCellType = .baseURL
        baseURL.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(baseURL)
        
        let labelSwitch = LabelModel()
        labelSwitch.labelTitle = INTERACTION_REPORT_ON_OFF
        labelSwitch.settingsCellType = .labelSwitch
        labelSwitch.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(labelSwitch)
        
        let deviceToken = LabelModel()
        deviceToken.labelTitle = DEVICES_TOKEN
        deviceToken.settingsCellType = .deviceToken
        deviceToken.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(deviceToken)
        
        let tokenLabel = LabelModel()
        tokenLabel.labelTitle = getDeviceTokenString() ?? TOKEN_LABEL
        tokenLabel.settingsCellType = .tokenLabel
        tokenLabel.cellIdentifier = String(describing: LabelCell.self)
        modelArray.append(tokenLabel)
        
        let clipboard = ButtonModel()
        clipboard.buttonTitle = COPY_TO_CLIPBOARD
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
