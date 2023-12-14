import Foundation
import UIKit

extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static let myPrimaryColor: UIColor = UIColor(r: 52, g: 145, b: 207)
    
    static let mySecondaryColor: UIColor = UIColor(r: 247, g: 32, b: 31)
}
