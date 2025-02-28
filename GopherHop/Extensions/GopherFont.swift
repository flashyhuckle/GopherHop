import SwiftUI

enum GopherFontSize {
    case small
    case medium
    case large
}

struct GopherFont: ViewModifier {
    let fontSize: GopherFontSize
    let lines: Int?
    
    func body(content: Content) -> some View {
        content
            .font(.custom("SFMono-Regular", size: getFont(for: fontSize)))
    }
    
    private func getFont(for size: GopherFontSize) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size.width
        
        switch size {
        case .small:
            return min(max(screenSize / CGFloat(lines ?? 80) * 1.50, screenSize / 45), 14)
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
