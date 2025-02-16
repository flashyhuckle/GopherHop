import SwiftUI

struct GopherView: View {
    @Binding var gopher: Gopher
    let lineTapped: ((GopherLine) -> Void)?
    
    init(gopher: Binding<Gopher>, lineTapped: ((GopherLine) -> Void)? = nil) {
        _gopher = gopher
        self.lineTapped = lineTapped
    }
    
    var body: some View {
        switch gopher.hole {
        case .lines(let lines):
            GopherLineView(lines: lines, scrollTo: gopher.scrollToLine, scrollToOffset: gopher.scrollToLineOffset, lineTapped: lineTapped)
        case .image, .gif, .text:
            GopherFileView(gopher: gopher)
        default:
            Text("unsupported gopher hole")
        }
    }
}

//#Preview {
//    GopherView()
//}


