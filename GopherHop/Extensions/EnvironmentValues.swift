import SwiftUI

extension EnvironmentValues {
    @Entry var motive: SettingsColorMotive = .system
}

extension View {
    func setMotive(_ motive: SettingsColorMotive) -> some View {
        environment(\.motive, motive)
    }
}

final class AppSettings: ObservableObject {
    @Published var motive: SettingsColorMotive = .system
    @Published var gopherPosition: SettingsHelperPosition = .auto
    
    private let settings: SettingsType
    
    static let shared = AppSettings()
    
    private init(settings: SettingsType = Settings()) {
        self.settings = settings
        refreshSettings()
    }
    
    func refreshSettings() {
        motive = settings.getMotive()
        gopherPosition = settings.getHelperPosition()
    }
}
