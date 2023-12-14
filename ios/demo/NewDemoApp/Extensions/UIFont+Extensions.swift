import Foundation
import UIKit

enum FontFamily: String {
    case system = ""
    case helvetica = "Helvetica"
    case helveticaNeue = "Helvetica Neue"
    case attAleckSans = "ATT Aleck Sans"
    case quicksand = "Quicksand"
}

extension UIFont {
    static var appFont: FontFamily = .system
    
    static func appThinFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "thin".isContained(in: font) && !"italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appUltraLightFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appUltraLightFont(ofSize: checkedSize)
    }

    static func appThinItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "thin".isContained(in: font) && "italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appUltraLightItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appUltraLightItalicFont(ofSize: checkedSize)
    }

    static func appUltraLightFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "ultralight".isContained(in: font) && !"italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appLightFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appLightFont(ofSize: checkedSize)
    }

    static func appUltraLightItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "ultralight".isContained(in: font) && "italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appLightItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appLightItalicFont(ofSize: checkedSize)
    }

    static func appLightFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "light".isContained(in: font) && !"italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appFont(ofSize: checkedSize)
    }

    static func appLightItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "light".isContained(in: font) && "italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appItalicFont(ofSize: checkedSize)
    }

    static func appFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if !"italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) && !"wide".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return defaultFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return defaultFont(ofSize: checkedSize)
    }

    static func appItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) && !"wide".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appFont(ofSize: checkedSize)
    }

    static func appMediumFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "medium".isContained(in: font) && !"italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appFont(ofSize: checkedSize)
    }

    static func appMediumItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "medium".isContained(in: font) && "italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appItalicFont(ofSize: checkedSize)
    }

    static func appSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "emibold".isContained(in: font) && !"italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appMediumFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appMediumFont(ofSize: checkedSize)
    }

    static func appSemiBoldItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "emibold".isContained(in: font) && "italic".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appMediumItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appMediumItalicFont(ofSize: checkedSize)
    }

    static func appBoldFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "bold".isContained(in: font) && !"italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appSemiBoldFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appSemiBoldFont(ofSize: checkedSize)
    }

    static func appBoldItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if "bold".isContained(in: font) && "italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appSemiBoldItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appSemiBoldItalicFont(ofSize: checkedSize)
    }

    static func appUltraBoldFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if ("trabold".isContained(in: font) && !"italic".isContained(in: font)) || ("condensedbold".isContained(in: font) && !"italic".isContained(in: font)) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appBoldFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appBoldFont(ofSize: checkedSize)
    }

    static func appUltraBoldItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if ("trabold".isContained(in: font) && "italic".isContained(in: font)) || ("condensedbold".isContained(in: font) && "italic".isContained(in: font)) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appBoldItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appBoldItalicFont(ofSize: checkedSize)
    }

    static func appBlackFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if ("black".isContained(in: font) && !"italic".isContained(in: font)) || ("heavy".isContained(in: font) && !"italic".isContained(in: font)) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appUltraBoldFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appUltraBoldFont(ofSize: checkedSize)
    }

    static func appBlackItalicFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        guard UIFont.appFont != .system else {
            return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
        }
        
        let fontFamily = UIFont.fontNames(forFamilyName: UIFont.appFont.rawValue)
        for font in fontFamily {
            if ("black".isContained(in: font) && "italic".isContained(in: font)) || ("heavy".isContained(in: font) && "italic".isContained(in: font)) {
                guard let returnFont = UIFont(name: font, size: checkedSize) else {
                    return appUltraBoldItalicFont(ofSize: checkedSize)
                }
                return scale(font: returnFont, ofSize: checkedSize)
            }
        }
        
        return appUltraBoldItalicFont(ofSize: checkedSize)
    }
    
    static func defaultFont(ofSize size: CGFloat) -> UIFont {
        let checkedSize = checkSize(size)
        return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
    }

    private static func scale(font: UIFont, ofSize size: CGFloat) -> UIFont {
        switch size {
        case 1...6:
            return UIFontMetrics(forTextStyle: .caption2).scaledFont(for: font)
        case 7...12:
            return UIFontMetrics(forTextStyle: .caption1).scaledFont(for: font)
        case 13...18:
            return UIFontMetrics(forTextStyle: .footnote).scaledFont(for: font)
        case 19...24:
            return UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: font)
        case 25...30:
            return UIFontMetrics(forTextStyle: .callout).scaledFont(for: font)
        case 31...36:
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        case 37...42:
            return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
        case 43...48:
            return UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
        case 49...54:
            return UIFontMetrics(forTextStyle: .title2).scaledFont(for: font)
        case 55...60:
            return UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
        default:
            if size > 60 {
                return UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
            }
        }
        return scale(font: font, ofSize: 17)
    }

    private static func checkSize(_ size: CGFloat) -> CGFloat {
        if size <= 0 {
            return 17
        } else {
            return size
        }
    }
}
