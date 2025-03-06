import SwiftUI

struct GopherLineView: View {
    let lines: [GopherLine]
    let scrollTo: GopherLine.ID?
    let scrollToOffset: CGFloat?
    let lineTapped: ((GopherLine) -> Void)?
    
    @State private var maxLineSize: Int?
    @State private var padding: CGFloat = 5.0
    
    @AppStorage(GopherConstants.Settings.motive) private var motive: SettingsColorMotive?
    
    init(
        lines: [GopherLine],
        scrollTo: ScrollToGopher? = nil,
        lineTapped: ((GopherLine) -> Void)? = nil
    ) {
        self.lines = lines
        self.scrollTo = scrollTo?.scrollToID
        self.scrollToOffset = scrollTo?.scrollToOffset
        self.lineTapped = lineTapped
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(lines, id: \.id) { line in
                            switch line.lineType {
                            case .directory, .text, .image, .gif, .search, .html:
                                Button {
                                    lineTapped?(line)
                                } label: {
                                    GopherLineSubView(line: line, lineCount: maxLineSize)
                                }
                                .buttonStyle(.plain)
                            default:
                                GopherLineSubView(line: line, lineCount: maxLineSize)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
                .onChange(of: lines) {
                    calculateView(in: proxy, geometry: geometry)
                }
                .onAppear {
                    calculateView(in: proxy, geometry: geometry)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.gopherBackground(for: motive))
        }
    }
    
    private func calculateView(in proxy: ScrollViewProxy, geometry: GeometryProxy) {
        if let scrollTo {
            proxy.scrollTo(scrollTo, anchor: UnitPoint(x: 0, y: (scrollToOffset ?? 0) / geometry.size.height))
        } else {
#warning("check if else is needed")
            proxy.scrollTo(lines.first?.id, anchor: .top)
        }
        maxLineSize = lines.reduce(1) { $1.message.count > $0 ? $1.message.count : $0 }
    }
}

struct GopherLineSubView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @AppStorage(GopherConstants.Settings.motive) private var motive: SettingsColorMotive?
    
    let line: GopherLine
    let lineCount: Int?
    
    init(line: GopherLine, lineCount: Int? = nil) {
        self.line = line
        self.lineCount = lineCount
    }
    
    var body: some View {
        Text(getText())
            .gopherFont(size: getFontSize(), lines: lineCount)
            .foregroundStyle(color())
            .lineLimit(1)
    }
    
    private func getText() -> String {
        switch line.lineType {
        case .directory: return GopherConstants.GopherView.LineView.directory + line.message
        case .text:      return GopherConstants.GopherView.LineView.text + line.message
        case .image:     return GopherConstants.GopherView.LineView.image + line.message
        case .gif:       return GopherConstants.GopherView.LineView.gif + line.message
        case .search:    return GopherConstants.GopherView.LineView.search + line.message
        case .html:      return GopherConstants.GopherView.LineView.html + line.message
        case .doc, .rtf, .pdf, .xml: return "[\(line.lineType)]" + line.message
        default:         return line.message
        }
    }
    
    private func getFontSize() -> GopherFontSize {
        #if os(macOS)
        return .large
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .large
        } else {
            return verticalSizeClass == .compact ? .medium : .scalable
        }
        #endif
    }
    
    private func color() -> Color {
        switch line.lineType {
        case .directory, .search, .html:
            return .gopherHole(for: motive)
        case .text:
            return .gopherDocument(for: motive)
        case .image, .gif:
            return .gopherImage(for: motive)
        case .doc, .rtf, .pdf, .xml:
            return .gopherUnsupported(for: motive)
        default:
            return .gopherText(for: motive)
        }
    }
}

#Preview {
    let lines = [GopherLine()]
    let lineTapped: ((GopherLine) -> Void) = { _ in }
    GopherLineView(lines: lines, lineTapped: lineTapped)
}
