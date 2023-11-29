import UIKit

enum LoginCellType: Int {
    case accessToken = 0
    case appID
    case register
    case doubleButton
}

class BaseModel: NSObject {
    var cellIdentifier: String?
    var loginCellType: LoginCellType?
}
