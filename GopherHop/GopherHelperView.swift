import SwiftUI

enum GopherHelperPosition {
    case up, down
}

struct GopherHelperView: View {
    @State private  var isHelperExpanded: Bool = false
    @Binding var helperPosition: GopherHelperPosition
    
    let settingsTapped: () -> Void
    let reloadTapped: () -> Void
    let homeTapped: () -> Void
    let globeTapped: () -> Void
    
#warning("calculate gopher helper position and size, eliminate hardcoded values")
    private let size = 80.0
    private let expandedSize = 320.0
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: size, height: size))
                    .foregroundStyle(isHelperExpanded ? .gray : .clear)
                HStack {
                    if isHelperExpanded {
                        Button {
                            settingsTapped()
                        } label: {
                            Image(systemName: "gear")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 8))
                        }
                        
                        Button {
                            reloadTapped()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                        }
                        
                        Button {
                            homeTapped()
                        } label: {
                            Image(systemName: "house")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                        }
                        
                        Button {
                            globeTapped()
                        } label: {
                            Image(systemName: "globe")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                        }
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
            .frame(width: isHelperExpanded ? expandedSize : size, height: size)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: size, height: size)))
            .position(x: reader.size.width - (isHelperExpanded ? 200 : size), y: helperPosition == .down ? reader.size.height - 50 : 50)
        }
        .animation(.interactiveSpring(duration: 0.3), value: isHelperExpanded)
        .onChange(of: helperPosition) { isHelperExpanded = false }
    }
}

#Preview {
    @Previewable @State var position = GopherHelperPosition.down
    @Previewable let homeTapped: () -> Void = {}
    @Previewable let settingsTapped: () -> Void = {}
    @Previewable let globeTapped: () -> Void = {}
    @Previewable let reloadTapped: () -> Void = {}
    GopherHelperView(
        helperPosition: $position,
        settingsTapped: settingsTapped,
        reloadTapped: reloadTapped,
        homeTapped: homeTapped,
        globeTapped: globeTapped
    )
}
