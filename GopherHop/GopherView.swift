import SwiftUI

struct GopherView: View {
    @Binding var gopher: Gopher
    let lineTapped: (GopherLine) -> Void
    
    var body: some View {
        switch gopher.hole {
        case .lines(let lines), .text(let lines):
            ScrollViewReader { proxy in
                GopherLineView(lines: lines, lineTapped: lineTapped)
                    .onChange(of: gopher) { oldValue, newValue in
                        if let target = gopher.scrollToLine {
                            print("scrolled to target")
//                            proxy.scrollTo(target)
//                            proxy.scrollTo(0, anchor: .top)
                        } else {
                            print("scrolled to top")
//                            proxy.scrollTo(0, anchor: .top)
                        }
                    }
            }
            
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
