import SwiftUI

struct GopherFileView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @State var hole: GopherHole
    
    var body: some View {
        Group {
            switch hole {
            case .image(let image), .gif(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            case .text(let text):
                ScrollView {
                    Text(text)
                        .font(.custom("SFMono-Regular", size: getFontSize()))
                        .foregroundStyle(Color(UIColor.gopherColor(.text)))
                }
            default:
                Text("something went wrong")
            }
        }
    }
    
    private func getFontSize() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 16
        } else {
            return verticalSizeClass == .compact ? 14 : 8
        }
    }
}

#Preview {
    let hole = GopherHole.lines([])
    GopherFileView(hole: hole)
}
