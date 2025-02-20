import SwiftUI

struct SettingsView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            Button {
                isVisible = false
            } label: {
                Text("Tap me")
                    .padding()
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            }
        }
    }
}

#Preview {
    @Previewable @State var isVisible = true
    SettingsView(isVisible: $isVisible)
}
