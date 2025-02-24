import SwiftUI

struct SettingsView: View {
    @Binding var isSettingsVisible: Bool
    
    private let settings: SettingsType = Settings()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            VStack {
                Text("pick a motive")
                HStack {
                    ForEach(SettingsColorMotive.allCases, id: \.self) { motive in
                        VStack {
                            Text(motive.rawValue)
                            Button {
                                settings.setMotive(motive)
                            } label: {
                                SettingsMotiveSubview(motive: motive)
                            }
                        }
                    }
                }
                
                Button {
                    isSettingsVisible = false
                } label: {
                    Text("Dismiss")
                        .padding()
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                }
            }
        }
    }
}

struct SettingsMotiveSubview: View {
    let motive: SettingsColorMotive
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .frame(width: 100, height: 130)
                .foregroundStyle(Color(UIColor.gopherColorPreview(.background, for: motive)))
            VStack {
                Text("Information")
                    .foregroundStyle(Color(UIColor.gopherColorPreview(.text, for: motive)))
                Text("Gopher")
                    .foregroundStyle(Color(UIColor.gopherColorPreview(.gopherHole, for: motive)))
                Text("Document")
                    .foregroundStyle(Color(UIColor.gopherColorPreview(.documentHole, for: motive)))
                Text("Image/gif")
                    .foregroundStyle(Color(UIColor.gopherColorPreview(.imageHole, for: motive)))
                Text("No-support")
                    .foregroundStyle(Color(UIColor.gopherColorPreview(.unsupportedHole, for: motive)))
            }
        }
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(UIColor.gopherColorPreview(.text, for: motive)).opacity(0.3), lineWidth: 2)
            )
        
    }
}

#Preview {
    @Previewable @State var isVisible = true
    SettingsView(isSettingsVisible: $isVisible)
}
