import UIKit

class ClearTextFieldButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        customInit()
    }
    
    func customInit() {
        setTitle("X", for: .normal)
        setTitleColor(.gray, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        backgroundColor = .clear
        isHidden = true
    }
}
