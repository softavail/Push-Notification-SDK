import Foundation

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
