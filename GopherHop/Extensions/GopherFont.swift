import SwiftUI

enum GopherFontSize: CGFloat {
    case small = 8
    case medium = 14
    case large = 16
}

struct GopherFont: ViewModifier {
    let fontSize: GopherFontSize
    
    func body(content: Content) -> some View {
        content
            .font(.custom("SFMono-Regular", size: fontSize.rawValue))
    }
}

extension View {
    func gopherFont(size: GopherFontSize) -> some View {
        modifier(GopherFont(fontSize: size))
    }
}
