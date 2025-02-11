import SwiftUI

enum GopherHelperPosition {
    case up, down
}

struct GopherHelperView: View {
    @Binding var isHelperExpanded: Bool
    @State private var size = 80.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: size, height: size))
                .foregroundStyle(isHelperExpanded ? .gray : .clear)
            HStack {
                if isHelperExpanded {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 8))
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    Image(systemName: "house")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    Image(systemName: "globe")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    Spacer()
                }
                
                Image("gopher")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: size, height: size)
                    .onTapGesture {
                        isHelperExpanded.toggle()
                    }
            }
        }
        .frame(width: isHelperExpanded ? 4*size : size, height: size)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: size, height: size)))
    }
}

#Preview {
    @Previewable @State var expanded = true
    GopherHelperView(isHelperExpanded: $expanded)
}
