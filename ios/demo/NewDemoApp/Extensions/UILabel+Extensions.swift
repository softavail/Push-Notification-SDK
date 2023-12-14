import Foundation
import UIKit

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
