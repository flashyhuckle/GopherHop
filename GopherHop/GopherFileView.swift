import SwiftUI

struct GopherFileView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    @State var gopher: Gopher
    
    var body: some View {
        Group {
            switch gopher.hole {
            case .image(let image), .gif(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            case .text(let text):
                ScrollView {
                    Text(text)
                        .font(.custom("SFMono-Regular", size: getFontSize()))
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
    let gopher = Gopher()
    GopherFileView(gopher: gopher)
}
