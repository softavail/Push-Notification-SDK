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
        registerButton.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(registerButton)
        
        let registerButton1 = ButtonModel()
        registerButton1.buttonTitle = "Register"
        registerButton1.loginCellType = .register
        registerButton1.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(registerButton1)
        
        let registerButton2 = ButtonModel()
        registerButton2.buttonTitle = "Register"
        registerButton2.loginCellType = .register
        registerButton2.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(registerButton2)
        
        let registerButton3 = ButtonModel()
        registerButton3.buttonTitle = "Register"
        registerButton3.loginCellType = .register
        registerButton3.cellIdentifier = String(describing: ButtonCell.self)
        modelArray.append(registerButton3)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
