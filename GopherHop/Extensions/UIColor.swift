import UIKit
import SwiftUI

enum GopherColorScheme: String {
    case background
    case documentHole
    case gopherHole
    case imageHole
    case text
    case unsupportedHole
}

extension UIColor {
    static func gopherColor(_ name: GopherColorScheme) -> UIColor {
        let theme = Settings().getMotive().rawValue
        let colorName = theme + "-" + name.rawValue
        return UIColor(named: colorName) ?? .black
    }
    
    static func gopherColor(_ name: GopherColorScheme, for motive: SettingsColorMotive) -> UIColor {
        let theme = motive.rawValue
        let colorName = theme + "-" + name.rawValue
        return UIColor(named: colorName) ?? .black
    }
}

extension Color {
    static func gopherBackground(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.background, for: motive ?? .system))
    }
    
    static func gopherDocument(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.documentHole, for: motive ?? .system))
    }
    
    static func gopherHole(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.gopherHole, for: motive ?? .system))
    }
    
    static func gopherImage(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.imageHole, for: motive ?? .system))
    }
    
    static func gopherText(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.text, for: motive ?? .system))
    }
    
    static func gopherUnsupported(for motive: SettingsColorMotive?) -> Color {
        Color(UIColor.gopherColor(.unsupportedHole, for: motive ?? .system))
    }
}
