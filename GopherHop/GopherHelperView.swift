import SwiftUI

enum GopherHelperPosition {
    case top, bottom
}

struct GopherHelperView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    @AppStorage(SettingsConstants.helper) private var helper: SettingsHelperPosition = .auto
    
    @State private  var isHelperExpanded: Bool = false
    @Binding var helperPosition: GopherHelperPosition
    @Binding var isLoading: Bool
    
    let settingsTapped: () -> Void
    let reloadTapped: () -> Void
    let homeTapped: () -> Void
    let bookmarkTapped: () -> Void
    let globeTapped: () -> Void
   
    
    init(
        helperPosition: Binding<GopherHelperPosition>,
        isLoading: Binding<Bool>,
        settingsTapped: @escaping () -> Void = {},
        reloadTapped: @escaping () -> Void = {},
        homeTapped: @escaping () -> Void = {},
        bookmarkTapped: @escaping () -> Void = {},
        globeTapped: @escaping () -> Void = {}
    ) {
        _helperPosition = helperPosition
        _isLoading = isLoading
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
                      y: helperYPosition(reader))
        }
        .animation(.interactiveSpring(duration: 0.3), value: isHelperExpanded)
        .animation(.bouncy, value: helperPosition)
        .onChange(of: helperPosition) {
            isHelperExpanded = false
        }
    }
    
    private func helperXPosition(_ reader: GeometryProxy) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return isHelperExpanded
            ? reader.size.width - expandedSize / 2 - size / 2
            : reader.size.width - size
        } else {
            return isHelperExpanded
            ? verticalSizeClass == .compact ? reader.size.width - expandedSize / 2 - size / 2 : reader.size.width / 2
            : verticalSizeClass == .compact ? reader.size.width - size : reader.size.width / 2 + expandedSize / 2 - size / 2
        }
    }
    
    private func helperYPosition(_ reader: GeometryProxy) -> CGFloat {
        helper == .auto
        ? helperPosition == .bottom ? reader.size.height - size/2 : size * 0.75
        : (helper == .top
           ? size * 0.75
           : reader.size.height - size/2
          )
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
    @Previewable @State var isLoading = true
    GopherHelperView(
        helperPosition: $position, isLoading: $isLoading
    )
}
