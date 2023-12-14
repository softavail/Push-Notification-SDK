import Foundation
import UIKit

let appFont = "Helvetica Neue"

func appThinFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appThinItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appUltraLightFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appUltraLightItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appLightFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appLightItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appMediumFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appMediumItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appSemiBoldFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appSemiBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appBoldFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appUltraBoldFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appUltraBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appBlackFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func appBlackItalicFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
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

func scale(font: UIFont, ofSize size: CGFloat) -> UIFont {
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

func checkSize(_ size: CGFloat) -> CGFloat {
    if size <= 0 {
        return 17
    } else {
        return size
    }
}

func defaultFont(ofSize size: CGFloat) -> UIFont {
    let checkedSize = checkSize(size)
    return scale(font: UIFont.systemFont(ofSize: checkedSize), ofSize: checkedSize)
}
