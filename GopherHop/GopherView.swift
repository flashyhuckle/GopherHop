import SwiftUI

struct GopherView: View {
    @Binding var gopher: Gopher
    let lineTapped: (GopherLine) -> Void
    
    var body: some View {
        switch gopher.hole {
        case .lines(let lines), .text(let lines):
            GopherLineView(lines: lines, scrollTo: gopher.scrollToLine, lineTapped: lineTapped)
        case .image, .gif:
            GopherFileView(gopher: gopher)
        default:
            Text("unsupported gopher hole")
        }
    }
}

//#Preview {
//    GopherView()
//}
