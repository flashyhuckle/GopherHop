import SwiftUI

struct GopherLineView: View {
    let lines: [GopherLine]
    let scrollTo: GopherLine.ID?
    let scrollToOffset: CGFloat?
    let lineTapped: (GopherLine) -> Void
    
    init(lines: [GopherLine], scrollTo: GopherLine.ID? = nil, scrollToOffset: CGFloat? = nil, lineTapped: @escaping (GopherLine) -> Void) {
        self.lines = lines
        self.scrollTo = scrollTo
        self.scrollToOffset = scrollToOffset
        self.lineTapped = lineTapped
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(lines, id: \.id) { line in
                        switch line.lineType {
                        case .directory, .text, .image, .gif:
                            Button {
                                lineTapped(line)
                            } label: {
                                GopherLineSubView(line: line)
                            }
                        default:
                            GopherLineSubView(line: line)
                        }
                    }
                }
            }
            .onChange(of: scrollTo) { _,_ in
                if let scrollTo {
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
    }
}

struct GopherLineSubView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    let line: GopherLine
    
    var body: some View {
        Text(getText())
            .font(.custom("SFMono-Regular", size: getFontSize()))
            .foregroundStyle(color())
    }
    
    private func getText() -> String {
        switch line.lineType {
        case .directory: return "[>]" + line.message
        case .text:      return "[=]" + line.message
        case .image:     return "[img]" + line.message
        case .gif:       return "[gif]" + line.message
        
        case .search:    return "[⌕]" + line.message
        case .doc, .rtf, .html, .pdf, .xml: return "[=]" + line.message
            
        default:         return line.message
        }
    }
    
    private func getFontSize() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 16
        } else {
            return verticalSizeClass == .compact ? 14 : 8
        }
    }
    
    private func color() -> Color {
        switch line.lineType {
        case .directory: return .blue
        case .text:      return .brown
        case .image, .gif:return .green
        case .doc, .rtf, .html, .pdf, .xml: return .red
        default:         return Color.primary
        }
    }
}

#Preview {
    let lines = [GopherLine()]
    let lineTapped: ((GopherLine) -> Void) = { _ in }
    GopherLineView(lines: lines, lineTapped: lineTapped)
}
