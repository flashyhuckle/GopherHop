import UIKit

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
    
    static func gopherColorPreview(_ name: GopherColorScheme, for motive: SettingsColorMotive) -> UIColor {
        let theme = motive.rawValue
        let colorName = theme + "-" + name.rawValue
        return UIColor(named: colorName) ?? .black
    }
}

