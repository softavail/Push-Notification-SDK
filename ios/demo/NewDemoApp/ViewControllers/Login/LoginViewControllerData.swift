import UIKit

class LoginViewControllerData: NSObject {
    func getLoginDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let accessToken = TextFieldModel()
        accessToken.labelTitle = "Access token"
        accessToken.textFieldValue = ""
        accessToken.textFieldPlaceholder = "Enter your access token"
        accessToken.loginCellType = .accessToken
        accessToken.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(accessToken)
        
        let appID = TextFieldModel()
        appID.labelTitle = "App ID"
        appID.textFieldValue = ""
        appID.textFieldPlaceholder = "Enter your app ID"
        appID.loginCellType = .appID
        appID.cellIdentifier = String(describing: TextFieldCell.self)
        modelArray.append(appID)
        
        let registerButton = ButtonModel()
        registerButton.buttonTitle = "Register"
        registerButton.loginCellType = .register
        registerButton.cellIdentifier = String(describing: RegisterButtonCell.self)
        modelArray.append(registerButton)
        
        let doubleButton = DoubleButtonModel()
        doubleButton.leftButtonTitle = "Go to Inbox"
        doubleButton.rightButtonTitle = "Reset Badge"
        doubleButton.loginCellType = .doubleButton
        doubleButton.cellIdentifier = String(describing: DoubleButtonCell.self)
        modelArray.append(doubleButton)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
