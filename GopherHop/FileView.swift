import SwiftUI

struct FileView: View {
    @State var gopher: Gopher
    
    var body: some View {
        Group {
            switch gopher.hole {
            case .image(let uIImage):
                Image(uiImage: uIImage)
            case .text(let array):
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(array, id: \.id) { line in
                            GopherLineView(line: line, onTap: {_,_ in})
                        }
                    }
                }
            case .lines:
                Text("loading...")
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
