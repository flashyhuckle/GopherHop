import SwiftUI

struct GopherView: View {
    @Binding var gopher: Gopher
    let lineTapped: (GopherLine) -> Void
    
    var body: some View {
        switch gopher.hole {
        case .lines(let lines), .text(let lines):
            GopherLineView(lines: lines, lineTapped: lineTapped)
        case .image:
            FileView(gopher: gopher)
        default:
            Text("loading?")
        }
    }
}

//#Preview {
//    GopherView()
//}
