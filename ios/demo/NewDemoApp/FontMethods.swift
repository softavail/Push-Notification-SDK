import Foundation
import UIKit

let appFont = "Helvetica Neue"

func appThinFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appUltraLightFontOfSize(size: newSize)
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

func appThinItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appUltraLightItalicFontOfSize(size: newSize)
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

func appUltraLightFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appLightFontOfSize(size: newSize)
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

func appUltraLightItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appLightItalicFontOfSize(size: newSize)
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

func appLightFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appFontOfSize(size: newSize)
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

func appLightItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appItalicFontOfSize(size: newSize)
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

func appFontOfSize(size: CGFloat) -> UIFont {
    let newSize: CGFloat
    if size <= 0 {
        newSize = 17
    } else {
        newSize = size
    }
    
    var returnFont: UIFont!
    let fontFamily = UIFont.fontNames(forFamilyName: appFont)
    for font in fontFamily {
        if appFont.removeAllWhiteSpaces().isContained(in: font) && !"italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) {
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

func appItalicFontOfSize(size: CGFloat) -> UIFont {
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
        if "italic".isContained(in: font) && !"thin".isContained(in: font) && !"light".isContained(in: font) && !"medium".isContained(in: font) && !"bold".isContained(in: font) && !"black".isContained(in: font) && !"heavy".isContained(in: font) && !"condensed".isContained(in: font) && !"roman".isContained(in: font) {
            returnFont = UIFont(name: font, size: newSize)
        }
    }
    
    if returnFont == nil {
        returnFont = appFontOfSize(size: newSize)
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

func appMediumFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appFontOfSize(size: newSize)
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

func appMediumItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appItalicFontOfSize(size: newSize)
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

func appSemiBoldFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appMediumFontOfSize(size: newSize)
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

func appSemiBoldItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appMediumItalicFontOfSize(size: newSize)
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

func appBoldFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appSemiBoldFontOfSize(size: newSize)
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

func appBoldItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appSemiBoldItalicFontOfSize(size: newSize)
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

func appUltraBoldFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appBoldFontOfSize(size: newSize)
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

func appUltraBoldItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appBoldItalicFontOfSize(size: newSize)
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

func appBlackFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appUltraBoldFontOfSize(size: newSize)
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

func appBlackItalicFontOfSize(size: CGFloat) -> UIFont {
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
        returnFont = appUltraBoldItalicFontOfSize(size: newSize)
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
