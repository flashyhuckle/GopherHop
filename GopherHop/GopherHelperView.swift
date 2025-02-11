import SwiftUI

enum GopherHelperPosition {
    case up, down
}

struct GopherHelperView: View {
    @Binding var isHelperExpanded: Bool
    @State private var size = 80.0
    
    var body: some View {
            Image("gopher")
                .resizable()
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: size, height: size)))
                .frame(width: isHelperExpanded ? 3*size : size, height: size)
        
    }
}

#Preview {
    @Previewable @State var expanded = true
    GopherHelperView(isHelperExpanded: $expanded)
}
