import SwiftUI

struct GopherLineView: View {
    let lines: [GopherLine]
    let scrollTo: GopherLine.ID?
    let scrollToOffset: CGFloat?
    let lineTapped: ((GopherLine) -> Void)?
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
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
    
#warning("calculate padding?")
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(lines, id: \.id) { line in
                        switch line.lineType {
                        case .directory, .text, .image, .gif, .search:
                            Button {
                                lineTapped?(line)
                            } label: {
                                GopherLineSubView(line: line)
                            }
                        default:
                            GopherLineSubView(line: line)
                        }
                    }
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .onChange(of: scrollTo) { _,_ in
                if let scrollTo {
#warning("fix scrolling issues under lazyVstack - history is shifted")
#warning("change hardcoded 700 value to screen height")
                    proxy.scrollTo(scrollTo, anchor: UnitPoint(x: 0, y: (scrollToOffset ?? 0) / 700))
                } else {
                    proxy.scrollTo(lines.first, anchor: .top)
                }
            }
            .onAppear {
                if let scrollTo {
                    proxy.scrollTo(scrollTo, anchor: UnitPoint(x: 0, y: (scrollToOffset ?? 0) / 700))
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.gopherBackground(for: motive))
    }
}

struct GopherLineSubView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    let line: GopherLine
    
    var body: some View {
        Text(getText())
            .gopherFont(size: getFontSize())
            .foregroundStyle(color())
            .lineLimit(1)
    }
    
    private func getText() -> String {
        switch line.lineType {
        case .directory: return "[>]" + line.message
        case .text:      return "[=]" + line.message
        case .image:     return "[img]" + line.message
        case .gif:       return "[gif]" + line.message
        case .search:    return "[⌕]" + line.message
        case .doc, .rtf, .html, .pdf, .xml: return "[\(line.lineType)]" + line.message
        default:         return line.message
        }
    }
    
    private func getFontSize() -> GopherFontSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .large
        } else {
            return verticalSizeClass == .compact ? .medium : .small
        }
    }
    
    private func color() -> Color {
        switch line.lineType {
        case .directory, .search:
            return .gopherHole(for: motive)
        case .text:
            return .gopherDocument(for: motive)
        case .image, .gif:
            return .gopherImage(for: motive)
        case .doc, .rtf, .html, .pdf, .xml:
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
