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
