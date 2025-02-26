import SwiftUI

struct GopherView: View {
    let gopher: Gopher
    let lineTapped: ((GopherLine) -> Void)?
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    init(gopher: Gopher, lineTapped: ((GopherLine) -> Void)? = nil) {
        self.gopher = gopher
        self.lineTapped = lineTapped
    }
    
    var body: some View {
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

//#Preview {
//    GopherView()
//}


