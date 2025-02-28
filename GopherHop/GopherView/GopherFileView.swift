import SwiftUI

struct GopherFileView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @State var hole: GopherHole
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        ZStack {
            Color.gopherBackground(for: motive)
                .ignoresSafeArea()
            switch hole {
            case .image(let image), .gif(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            case .text(let text):
                ScrollView {
                    Text(text)
                        .gopherFont(size: getFontSize())
                        .foregroundStyle(Color.gopherText(for: motive))
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                .scrollIndicators(.hidden)
            default:
                Text("something went wrong")
            }
        }
    }
    
    private func getFontSize() -> GopherFontSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .large
        } else {
            return verticalSizeClass == .compact ? .medium : .small
        }
    }
}

#Preview {
    let hole = GopherHole.lines([])
    GopherFileView(hole: hole)
}
