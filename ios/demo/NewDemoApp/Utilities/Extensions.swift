import Foundation
import UIKit

extension String {
    func trimWhiteSpaces() -> String {
        var returnString = self
        
        while returnString.hasPrefix(" ") {
            returnString.removeFirst(1)
        }
        
        while returnString.hasSuffix(" ") {
            returnString.removeLast(1)
        }
        
        return returnString
    }
    
    func isContained(in string: String) -> Bool {
        if string.lowercased().contains(self.lowercased()) {
            return true
        } else {
            return false
        }
    }
}

extension UILabel {
    var textWidth: Double {
        guard let text = self.text else { return 0 }
        guard let font = self.font else { return 0 }
        
        let labelTextNSString = NSString(string: text)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let labelTextWidth = labelTextNSString.size(withAttributes: attrs).width
        
        return labelTextWidth
    }
}

extension UIButton {
    func enable() {
        self.isEnabled = true
        self.alpha = 1
    }
    
    func disable() {
        self.isEnabled = false
        self.alpha = 0.5
    }
}

extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
      }
    
    static let myPrimaryColor: UIColor = UIColor(r: 52, g: 145, b: 207)
    
    static let mySecondaryColor: UIColor = UIColor(r: 247, g: 32, b: 31)
}

extension Date {
    func customDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
