import SwiftUI

struct GopherLineView: View {
    let line: GopherLine
    let onTap: (GopherLine, GopherLineType?) -> Void
    
    var body: some View {
        Text(getText())
            .font(.custom("SFMono-Regular", size: 8))
            .foregroundStyle(color())
            .onTapGesture {
                buttonTapped()
            }
    }
    
    private func buttonTapped() {
        switch line.lineType {
        case .directory:
            onTap(line, nil)
        case .text:
            onTap(line, line.lineType)
        default:
            break
        }
    }
    
    private func getText() -> String {
        switch line.lineType {
        case .directory:
            return "[>]" + line.message
        case .text:
            return "[=]" + line.message
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
        default:
            return .black
        }
    }
}

#Preview {
    let line = GopherLine()
    let onTap: ((GopherLine, GopherLineType?) -> Void) = { _, _ in }
    GopherLineView(line: line, onTap: onTap)
}
