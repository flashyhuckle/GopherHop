import SwiftUI

struct SettingsView: View {
    let dismissTapped: (() -> Void)?
    private let settings: SettingsType = Settings()
    
    @State private var helperPosition: SettingsHelperPosition = .auto
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        List {
            Section(content: {
                HStack {
                    ForEach(SettingsColorMotive.allCases, id: \.self) { motive in
                        VStack {
                            Text(motive.rawValue)
                                .gopherFont(size: .large)
                                .foregroundStyle(Color.gopherText(for: self.motive))
                            Button {
                                settings.setMotive(motive)
                            } label: {
                                SettingsMotiveSubview(motive: motive, isChosen: motive == self.motive ?? .system)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listRowBackground(Color.gopherBackground(for: motive))
                
            }, header: {
                Text("pick a motive")
                    .gopherFont(size: .large)
                    .foregroundStyle(Color.gopherText(for: motive))
            })
            
            Section(content: {
                HStack {
                    ForEach(SettingsHelperPosition.allCases, id: \.self) { position in
                        Button {
                            helperPosition = position
                        } label: {
                            Text(position.rawValue)
                                .gopherFont(size: .large)
                                .foregroundStyle(Color.gopherText(for: motive))
                                .frame(width: 100, height: 50)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(position == self.helperPosition ? Color.gopherText(for: motive).opacity(0.5) : .clear, lineWidth: 4))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowBackground(Color.gopherBackground(for: motive))
            }, header: {
                Text("Helper position")
                    .gopherFont(size: .large)
                    .foregroundStyle(Color.gopherText(for: motive))
            })
            
            Section {
                Button {
                    dismissTapped?()
                } label: {
                    Text("Dismiss")
                        .gopherFont(size: .large)
                        .foregroundStyle(Color.gopherBackground(for: motive))
                }
                .listRowBackground(Color.gopherHole(for: motive))
            }
            
        }
        .animation(.default, value: helperPosition)
        .animation(.default, value: motive)
        .scrollContentBackground(.hidden)
        .background(Color.gopherBackground(for: motive))
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
    let isChosen: Bool
    
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
            .stroke(isChosen ? Color.gopherText(for: motive).opacity(0.5) : .clear, lineWidth: 4))
    }
}

#Preview {
    SettingsView(dismissTapped: nil)
}
