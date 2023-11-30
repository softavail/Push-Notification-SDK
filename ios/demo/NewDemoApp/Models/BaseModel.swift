import UIKit

enum LoginCellType: Int {
    case accessToken = 0
    case appID
    case register
    case doubleButton
}

enum SettingsCellType: Int {
    case baseURL
    case labelSwitch
    case deviceToken
    case tokenLabel
    case clipboard
}

class BaseModel: NSObject {
    var cellIdentifier: String?
    var loginCellType: LoginCellType?
    var settingsCellType: SettingsCellType?
}
