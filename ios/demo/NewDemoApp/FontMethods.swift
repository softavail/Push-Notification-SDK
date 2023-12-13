import Foundation
import UIKit

let appFont = "Helvetica Neue"

func appThinFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "thin".isContained(in: font) && !"italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appUltraLightFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appThinItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "thin".isContained(in: font) && "italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appUltraLightItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appUltraLightFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "ultralight".isContained(in: font) && !"italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appLightFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appUltraLightItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "ultralight".isContained(in: font) && "italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appLightItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appLightFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "light".isContained(in: font) && !"italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appLightItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "light".isContained(in: font) && "italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if !"italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) && !"wide".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    switch newSize {
    case 1...6:
        returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
    case 7...12:
        returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
    case 13...18:
        returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
    case 19...24:
        returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
    case 25...30:
        returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
    case 31...36:
        returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
    case 37...42:
        returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
    case 43...48:
        returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
    case 49...54:
        returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
    case 55...60:
        returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
    case 61...66:
        returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
    default:
        if newSize > 66 {
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        }
    }
    
    return returnFont
}

func appItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) && !"wide".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appMediumFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "medium".isContained(in: font) && !"italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appMediumItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "medium".isContained(in: font) && "italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appSemiBoldFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "emibold".isContained(in: font) && !"italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appMediumFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appSemiBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "emibold".isContained(in: font) && "italic".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appMediumItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appBoldFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "bold".isContained(in: font) && !"italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appSemiBoldFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if "bold".isContained(in: font) && "italic".isContained(in: font) && !"ultra".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"extra".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appSemiBoldItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appUltraBoldFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if ("trabold".isContained(in: font) && !"italic".isContained(in: font)) || ("condensedbold".isContained(in: font) && !"italic".isContained(in: font)) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appBoldFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appUltraBoldItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if ("trabold".isContained(in: font) && "italic".isContained(in: font)) || ("condensedbold".isContained(in: font) && "italic".isContained(in: font)) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appBoldItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appBlackFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if ("black".isContained(in: font) && !"italic".isContained(in: font)) || ("heavy".isContained(in: font) && !"italic".isContained(in: font)) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appUltraBoldFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}

func appBlackItalicFont(ofSize size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var isScaled = false
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if ("black".isContained(in: font) && "italic".isContained(in: font)) || ("heavy".isContained(in: font) && "italic".isContained(in: font)) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appUltraBoldItalicFont(ofSize: newSize)
        isScaled = true
    }
    
    if returnFont == nil {
        returnFont = UIFont.systemFont(ofSize: newSize)
    }
    
    if !isScaled {
        switch newSize {
        case 1...6:
            returnFont = UIFontMetrics(forTextStyle: .caption2).scaledFont(for: returnFont)
        case 7...12:
            returnFont = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: returnFont)
        case 13...18:
            returnFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: returnFont)
        case 19...24:
            returnFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: returnFont)
        case 25...30:
            returnFont = UIFontMetrics(forTextStyle: .callout).scaledFont(for: returnFont)
        case 31...36:
            returnFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: returnFont)
        case 37...42:
            returnFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: returnFont)
        case 43...48:
            returnFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: returnFont)
        case 49...54:
            returnFont = UIFontMetrics(forTextStyle: .title2).scaledFont(for: returnFont)
        case 55...60:
            returnFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: returnFont)
        case 61...66:
            returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
        default:
            if newSize > 66 {
                returnFont = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: returnFont)
            }
        }
    }
    
    return returnFont
}
