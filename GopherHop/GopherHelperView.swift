import SwiftUI

enum GopherHelperPosition {
    case top, bottom
}

struct GopherHelperView: View {
    @State private  var isHelperExpanded: Bool = false
    @Binding var helperPosition: GopherHelperPosition
    
    let settingsTapped: () -> Void
    let reloadTapped: () -> Void
    let homeTapped: () -> Void
    let bookmarkTapped: () -> Void
    let globeTapped: () -> Void
    
    init(
        helperPosition: Binding<GopherHelperPosition>,
        settingsTapped: @escaping () -> Void = {},
        reloadTapped: @escaping () -> Void = {},
        homeTapped: @escaping () -> Void = {},
        bookmarkTapped: @escaping () -> Void = {},
        globeTapped: @escaping () -> Void = {}
    ) {
        _helperPosition = helperPosition
        self.settingsTapped = settingsTapped
        self.reloadTapped = reloadTapped
        self.homeTapped = homeTapped
        self.bookmarkTapped = bookmarkTapped
        self.globeTapped = globeTapped
    }
    
#warning("calculate gopher helper position and size, eliminate hardcoded values")
    private let size = 80.0
    private let expandedSize = 340.0
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: size, height: size))
                    .foregroundStyle(isHelperExpanded ? Color(UIColor.gopherColor(.background)) : .clear)
                    .overlay(
                            RoundedRectangle(cornerRadius: size)
                                .stroke(isHelperExpanded ? Color(UIColor.gopherColor(.text)) : .clear, lineWidth: 2)
                        )
                HStack {
                    if isHelperExpanded {
                        Button {
                            settingsTapped()
                            isHelperExpanded = false
                        } label: {
                            Image(systemName: "gear")
                                .foregroundStyle(Color(UIColor.gopherColor(.text)))
                                .font(.largeTitle)
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        }
                        Button {
                            reloadTapped()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(Color(UIColor.gopherColor(.text)))
                                .font(.largeTitle)
                        }
                        
                        Button {
                            homeTapped()
                        } label: {
                            Image(systemName: "house")
                                .foregroundStyle(Color(UIColor.gopherColor(.text)))
                                .font(.largeTitle)
                        }
                        
                        Button {
                            bookmarkTapped()
                        } label: {
                            Image(systemName: "bookmark")
                                .foregroundStyle(Color(UIColor.gopherColor(.text)))
                                .font(.largeTitle)
                        }
                        
                        Button {
                            globeTapped()
                        } label: {
                            Image(systemName: "globe")
                                .foregroundStyle(Color(UIColor.gopherColor(.text)))
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
            .position(x: reader.size.width - (isHelperExpanded ? 200 : size - 10), y: helperPosition == .bottom ? reader.size.height - 50 : 50)
        }
        .animation(.interactiveSpring(duration: 0.3), value: isHelperExpanded)
        .animation(.bouncy, value: helperPosition)
        .onChange(of: helperPosition) { isHelperExpanded = false }
    }
}

#Preview {
    @Previewable @State var position = GopherHelperPosition.bottom
    GopherHelperView(
        helperPosition: $position
    )
}
