import SwiftUI

enum GopherFontSize {
    case scalable
    case small
    case medium
    case large
}

struct GopherFont: ViewModifier {
    let fontSize: GopherFontSize
    let lines: Int?
    
    func body(content: Content) -> some View {
        content
            .font(.custom(GopherConstants.Font.classic, size: getFont(for: fontSize)))
    }
    
    private func getFont(for size: GopherFontSize) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size.width
        
        switch size {
        case .scalable:
            return min(max(screenSize / CGFloat(lines ?? 80) * 1.50, screenSize / 45), 14)
        case .small:
            return 8
        case .medium:
            return 14
        case .large:
            return 16
        }
    }
}

extension View {
    func gopherFont(size: GopherFontSize, lines: Int? = nil) -> some View {
        modifier(GopherFont(fontSize: size, lines: lines))
    }
}
