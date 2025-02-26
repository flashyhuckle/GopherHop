import SwiftUI

struct SettingsView: View {
    let dismissTapped: (() -> Void)?
    private let settings: SettingsType = Settings()
    
    @State private var helperPosition: SettingsHelperPosition = .auto
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        ZStack {
            Color.gopherBackground(for: motive)
                .ignoresSafeArea()
            VStack {
                Text("pick a motive")
                    .gopherFont(size: .large)
                    .foregroundStyle(Color.gopherText(for: motive))
                HStack {
                    ForEach(SettingsColorMotive.allCases, id: \.self) { motive in
                        VStack {
                            Text(motive.rawValue)
                                .gopherFont(size: .large)
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
                
                Picker("Helper position", selection: $helperPosition) {
                    ForEach(SettingsHelperPosition.allCases, id: \.self) { position in
                        Text(position.rawValue)
                            .gopherFont(size: .large)
                    }
                }
                
                Button {
                    dismissTapped?()
                } label: {
                    Text("Dismiss")
                        .gopherFont(size: .large)
                        .padding()
                        .background(Color.gopherBackground(for: motive))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                }
            }
        }
        .onAppear {
            helperPosition = settings.getHelperPosition()
        }
        .onChange(of: helperPosition) {
            settings.setHelper(position: helperPosition)
        }
    }
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
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherText(for: motive))
                Text("Gopher")
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherHole(for: motive))
                Text("Document")
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherDocument(for: motive))
                Text("Image/gif")
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherImage(for: motive))
                Text("No-support")
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherUnsupported(for: motive))
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gopherText(for: motive).opacity(0.3), lineWidth: 2))
    }
}

#Preview {
    SettingsView(dismissTapped: nil)
}
