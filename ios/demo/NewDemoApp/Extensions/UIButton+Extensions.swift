import Foundation
import UIKit

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
