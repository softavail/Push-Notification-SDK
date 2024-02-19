import UIKit

class NewSettingsViewControllerData: NSObject {
    func getSettingsDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let baseURL = TextFieldButtonModel()
        baseURL.textFieldValue = SharedMethods.getBaseURL()
        baseURL.textFieldPlaceholder = BASE_URL
        baseURL.buttonTitle = SAVE
        baseURL.settingsCellType = .baseURL
        baseURL.cellIdentifier = String(describing: TextFieldButtonCell.self)
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
        tokenLabel.labelTitle = SharedMethods.getDeviceToken() ?? TOKEN_LABEL
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
}
