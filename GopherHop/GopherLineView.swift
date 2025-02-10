import SwiftUI

struct GopherLineView: View {
    let line: GopherLine
    let onTap: (GopherLine, GopherLineType?) -> Void
    
    var body: some View {
        switch line.lineType {
        case .directory, .text, .image:
            Button {
                buttonTapped()
            } label: {
                GopherLineSubView(line: line)
            }
//        case .text, .image:
//            NavigationLink {
//                FileView(line: line)
//            } label: {
//                GopherLineSubView(line: line)
//            }
        default:
            GopherLineSubView(line: line)
        }
    }
    
    private func buttonTapped() {
        switch line.lineType {
        case .directory:
            onTap(line, nil)
        case .text, .image:
            onTap(line, line.lineType)
        default:
            break
        }
    }
}

struct GopherLineSubView: View {
    let line: GopherLine
    
    var body: some View {
        Text(getText())
            .font(.custom("SFMono-Regular", size: 8))
            .foregroundStyle(color())
    }
    
    private func getText() -> String {
        switch line.lineType {
        case .directory:
            return "[>]" + line.message
        case .text:
            return "[=]" + line.message
        case .image:
            return "[img]" + line.message
        default:
            return line.message
        }
    }
    
    private func color() -> Color {
        switch line.lineType {
        case .directory:
            return .blue
        case .text:
            return .brown
        case .image:
            return .green
        default:
            return Color.primary
        }
    }
    
}

#Preview {
    let line = GopherLine()
    let onTap: ((GopherLine, GopherLineType?) -> Void) = { _, _ in }
    GopherLineView(line: line, onTap: onTap)
}
