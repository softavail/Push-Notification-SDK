import UIKit

class LoginViewControllerData: NSObject {
    func getLoginDataSource(token: String, appId: String) -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let accessToken = TextFieldModel()
        accessToken.labelTitle = ACCESS_TOKEN
        accessToken.textFieldValue = token
        accessToken.textFieldPlaceholder = ENTER_YOUR_ACCESS_TOKEN
        accessToken.loginCellType = .accessToken
        accessToken.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(accessToken)
        
        let appID = TextFieldModel()
        appID.labelTitle = APP_ID
        appID.textFieldValue = appId
        appID.textFieldPlaceholder = ENTER_YOUR_APP_ID
        appID.loginCellType = .appID
        appID.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(appID)
        
        let registerButton = ButtonModel()
        registerButton.buttonTitle = REGISTER
        registerButton.loginCellType = .register
        registerButton.cellIdentifier = String(describing: RegisterButtonCell.self)
        modelArray.append(registerButton)
        
        let resetBadgeButton = ButtonModel()
        resetBadgeButton.buttonTitle = RESET_BADGE
        resetBadgeButton.loginCellType = .resetBadge
        resetBadgeButton.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(resetBadgeButton)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
