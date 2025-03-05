import SwiftUI

struct SettingsView: View {
    let dismissTapped: (() -> Void)?
    private let settings: SettingsType = Settings()
    
    @State private var helperPosition: SettingsHelperPosition = .auto
    
    @AppStorage(GopherConstants.Settings.motive) private var motive: SettingsColorMotive?
    
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
                        if motive != SettingsColorMotive.allCases.last {
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color.gopherBackground(for: motive))
                
            }, header: {
                Text(GopherConstants.SettingsView.motiveSectionHeader)
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
                        if position != SettingsHelperPosition.allCases.last {
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color.gopherBackground(for: motive))
            }, header: {
                Text(GopherConstants.SettingsView.helperSectionHeader)
                    .gopherFont(size: .large)
                    .foregroundStyle(Color.gopherText(for: motive))
            })
            
            Section {
                Button {
                    dismissTapped?()
                } label: {
                    Text(GopherConstants.Buttons.dismiss)
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
                .foregroundStyle(Color.gopherBackground(for: motive))
            VStack {
                Text(GopherConstants.SettingsView.MotivePreviewTitles.information)
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherText(for: motive))
                Text(GopherConstants.SettingsView.MotivePreviewTitles.gopher)
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherHole(for: motive))
                Text(GopherConstants.SettingsView.MotivePreviewTitles.document)
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherDocument(for: motive))
                Text(GopherConstants.SettingsView.MotivePreviewTitles.image)
                    .gopherFont(size: .medium)
                    .foregroundStyle(Color.gopherImage(for: motive))
                Text(GopherConstants.SettingsView.MotivePreviewTitles.unsupported)
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
