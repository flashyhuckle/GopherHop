#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftUI

enum GopherColorScheme: String {
    case background
    case documentHole
    case gopherHole
    case imageHole
    case text
    case unsupportedHole
}
#if os(macOS)
extension NSColor {
    static func gopherColor(_ name: GopherColorScheme, for motive: SettingsColorMotive) -> NSColor {
        let theme = motive.rawValue
        let colorName = theme + "-" + name.rawValue
        return NSColor(named: colorName) ?? .black
    }
}
#else
extension UIColor {
    static func gopherColor(_ name: GopherColorScheme, for motive: SettingsColorMotive) -> UIColor {
        let theme = motive.rawValue
        let colorName = theme + "-" + name.rawValue
        return UIColor(named: colorName) ?? .black
    }
}
#endif

extension Color {
    static func gopherBackground(for motive: SettingsColorMotive?) -> Color {
        #if os(macOS)
        Color(NSColor.gopherColor(.background, for: motive ?? .system))
        #else
        Color(UIColor.gopherColor(.background, for: motive ?? .system))
        #endif
    }
    
    static func gopherDocument(for motive: SettingsColorMotive?) -> Color {
#if os(macOS)
        Color(NSColor.gopherColor(.documentHole, for: motive ?? .system))
#else
        Color(UIColor.gopherColor(.documentHole, for: motive ?? .system))
#endif
    }
    
    static func gopherHole(for motive: SettingsColorMotive?) -> Color {
#if os(macOS)
        Color(NSColor.gopherColor(.gopherHole, for: motive ?? .system))
#else
        Color(UIColor.gopherColor(.gopherHole, for: motive ?? .system))
#endif
    }
    
    static func gopherImage(for motive: SettingsColorMotive?) -> Color {
#if os(macOS)
        Color(NSColor.gopherColor(.imageHole, for: motive ?? .system))
#else
        Color(UIColor.gopherColor(.imageHole, for: motive ?? .system))
#endif
    }
    
    static func gopherText(for motive: SettingsColorMotive?) -> Color {
#if os(macOS)
        Color(NSColor.gopherColor(.text, for: motive ?? .system))
#else
        Color(UIColor.gopherColor(.text, for: motive ?? .system))
#endif
    }
    
    static func gopherUnsupported(for motive: SettingsColorMotive?) -> Color {
#if os(macOS)
        Color(NSColor.gopherColor(.unsupportedHole, for: motive ?? .system))
#else
        Color(UIColor.gopherColor(.unsupportedHole, for: motive ?? .system))
#endif
    }
}
