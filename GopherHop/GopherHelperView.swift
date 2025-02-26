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
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    @AppStorage(SettingsConstants.helper) private var helper: SettingsHelperPosition = .auto
    
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
    
    private let size = 80.0
    private let expandedSize = 340.0
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: size, height: size))
                    .foregroundStyle(isHelperExpanded ? Color.gopherBackground(for: motive) : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: size)
                            .stroke(isHelperExpanded ? Color.gopherText(for: motive) : .clear, lineWidth: 1)
                    )
                HStack {
                    if isHelperExpanded {
                        GopherHelperButtonView(name: "gear", onTap: settingsTapped)
                            .padding(EdgeInsets(top: 0, leading: size / 5, bottom: 0, trailing: 0))
                        GopherHelperButtonView(name: "arrow.clockwise", onTap: reloadTapped)
                        GopherHelperButtonView(name: "house", onTap: homeTapped)
                        GopherHelperButtonView(name: "bookmark", onTap: bookmarkTapped)
                        GopherHelperButtonView(name: "globe", onTap: globeTapped)
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
            .position(x: helperXPosition(reader),
                      y: helper == .auto
                      ? helperPosition == .bottom ? reader.size.height - size/2 : size/2
                      : (helper == .top
                         ? size/2
                         : reader.size.height - size/2)
            )
        }
        .animation(.interactiveSpring(duration: 0.3), value: isHelperExpanded)
        .animation(.bouncy, value: helperPosition)
        .onChange(of: helperPosition) {
            isHelperExpanded = false
        }
    }
    
    private func helperXPosition(_ reader: GeometryProxy) -> CGFloat {
        isHelperExpanded
        ? reader.size.width / 2
        : reader.size.width / 2 + expandedSize / 2 - size / 2
    }
}

struct GopherHelperButtonView: View {
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    let name: String
    let onTap: (() -> Void)
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: name)
                .foregroundStyle(Color.gopherText(for: motive))
                .font(.largeTitle)
        }
    }
}

#Preview {
    @Previewable @State var position = GopherHelperPosition.bottom
    GopherHelperView(
        helperPosition: $position
    )
}
