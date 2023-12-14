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
    
    func isContained(in string: String) -> Bool {
        if string.lowercased().contains(self.lowercased()) {
            return true
        } else {
            return false
        }
    }
}
