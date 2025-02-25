import SwiftUI

struct GopherView: View {
    @Binding var gopher: Gopher
    let lineTapped: ((GopherLine) -> Void)?
    
    @AppStorage("Motive") private var motive: SettingsColorMotive?
    
    init(gopher: Binding<Gopher>, lineTapped: ((GopherLine) -> Void)? = nil) {
        _gopher = gopher
        self.lineTapped = lineTapped
    }
    
    var body: some View {
        ZStack {
            Color.gopherBackground(for: motive)
                .ignoresSafeArea()
            switch gopher.hole {
            case .lines(let lines):
                GopherLineView(lines: lines, scrollTo: gopher.scrollTo, lineTapped: lineTapped)
            case .image, .gif, .text:
                GopherFileView(hole: gopher.hole)
            default:
                Text("unsupported gopher hole")
            }
        }
    }
}

//#Preview {
//    GopherView()
//}


