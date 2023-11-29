import UIKit

class BetterButton: UIButton {
    private var highlightedBackgroundColor: UIColor = UIColor.systemBlue
    private var disabledBackgroundColor: UIColor? {
        didSet {
            if !isEnabled {
                backgroundColor = disabledBackgroundColor
            }
        }
    }
    private var normalBackgroundColor: UIColor? {
        didSet {
            if isEnabled {
                backgroundColor = normalBackgroundColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        customInit()
    }
    
    func customInit() {
        if traitCollection.userInterfaceStyle != .dark {
            setBackgroundColor(.black)
            setTitleColor(.white, for: .normal)
        } else {
            setBackgroundColor(.white)
            setTitleColor(.black, for: .normal)
        }
        
        layer.cornerRadius = 15
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = normalBackgroundColor {
                    backgroundColor = color
                }
            } else {
                if let color = disabledBackgroundColor {
                    backgroundColor = color
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isEnabled {
                if isHighlighted {
                    backgroundColor = highlightedBackgroundColor
                } else {
                    if let color = normalBackgroundColor {
                        backgroundColor = color
                    }
                }
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        normalBackgroundColor = color
        disabledBackgroundColor = color.withAlphaComponent(0.5)
    }
}
