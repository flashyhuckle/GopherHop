import SwiftUI

struct FileView: View {
    @State var gopher: Gopher
    
    var body: some View {
        Group {
            switch gopher.hole {
            case .image(let uIImage):
                Image(uiImage: uIImage)
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
    FileView(gopher: gopher)
}
