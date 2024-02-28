import Foundation
import UIKit

extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static let myPrimaryColor: UIColor = UIColor(r: 43, g: 189, b: 251)
    
    static let mySecondaryColor: UIColor = UIColor(r: 247, g: 32, b: 31)
    
    static let separatorColor: UIColor = UIColor(r: 209, g: 211, b: 210)
    
    static let buttonColorAttachment: UIColor = UIColor(r: 2, g: 62, b: 110)
    static let buttonColorRead: UIColor = UIColor(r: 255, g: 0, b: 152)
    static let buttonColorDelivery: UIColor = UIColor(r: 255, g: 173, b: 41)
    static let buttonColorDelete: UIColor = UIColor(r: 255, g: 50, b: 31)
    static let buttonColorClickThru: UIColor = UIColor(r: 2, g: 209, b: 76)
    static let buttonColorDeepLink: UIColor = UIColor(r: 70, g: 68, b: 244)
}
