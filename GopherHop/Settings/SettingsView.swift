import SwiftUI

struct SettingsView: View {
    let dismissTapped: (() -> Void)?
    private let settings: SettingsType = Settings()
    
    @AppStorage("Motive") private var motive: SettingsColorMotive?
    
#warning("reload views after changing motive")
    var body: some View {
        ZStack {
            Color.gopherBackground(for: motive)
                .ignoresSafeArea()
            VStack {
                Text("pick a motive")
                    .foregroundStyle(Color.gopherText(for: motive))
                HStack {
                    ForEach(SettingsColorMotive.allCases, id: \.self) { motive in
                        VStack {
                            Text(motive.rawValue)
                                .foregroundStyle(Color.gopherText(for: self.motive))
                            Button {
                                settings.setMotive(motive)
                                AppSettings.shared.refreshSettings()
                            } label: {
                                SettingsMotiveSubview(motive: motive)
                            }
                        }
                    }
                }
                
                Button {
                    dismissTapped?()
                } label: {
                    Text("Dismiss")
                        .padding()
                        .background(Color.gopherBackground(for: motive))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                }
            }
        }
//        .onAppear {
//            getMotive()
//        }
        
    }
//    private func getMotive() {
//        colorMotive = settings.getMotive()
//    }
}

struct SettingsMotiveSubview: View {
    let motive: SettingsColorMotive
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .frame(width: 100, height: 130)
                .foregroundStyle(Color(UIColor.gopherColor(.background, for: motive)))
            VStack {
                Text("Information")
                    .foregroundStyle(Color(UIColor.gopherColor(.text, for: motive)))
                Text("Gopher")
                    .foregroundStyle(Color(UIColor.gopherColor(.gopherHole, for: motive)))
                Text("Document")
                    .foregroundStyle(Color(UIColor.gopherColor(.documentHole, for: motive)))
                Text("Image/gif")
                    .foregroundStyle(Color(UIColor.gopherColor(.imageHole, for: motive)))
                Text("No-support")
                    .foregroundStyle(Color(UIColor.gopherColor(.unsupportedHole, for: motive)))
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(UIColor.gopherColor(.text, for: motive)).opacity(0.3), lineWidth: 2))
    }
}

#Preview {
    SettingsView(dismissTapped: nil)
}
