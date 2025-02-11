import SwiftUI

struct GopherFileView: View {
    @State var gopher: Gopher
    
    var body: some View {
        Group {
            switch gopher.hole {
            case .image(let image), .gif(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            default:
                Text("something went wrong")
            }
        }
    }
}

#Preview {
    let gopher = Gopher()
    GopherFileView(gopher: gopher)
}
