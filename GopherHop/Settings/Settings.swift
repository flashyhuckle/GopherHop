import Foundation

protocol SettingsStorageType {
    func set(value: String, for key: String)
    func removeValue(for key: String)
    func getString(for key: String) -> String?
}

final class UserDefaultsSettingsStorage: SettingsStorageType {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func set(value: String, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    func removeValue(for key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func getString(for key: String) -> String? {
        defaults.string(forKey: key)
    }
}

protocol SettingsType {
    func setMotive(_ motive: SettingsColorMotive)
    func getMotive() -> SettingsColorMotive
    
    func setHelper(position: SettingsHelperPosition)
    func getHelperPosition() -> SettingsHelperPosition
}

final class Settings: SettingsType {
    let storage: SettingsStorageType
    
    init(storage: SettingsStorageType = UserDefaultsSettingsStorage()) {
        self.storage = storage
    }
    
    func setMotive(_ motive: SettingsColorMotive) {
        storage.set(value: motive.rawValue, for: "Motive")
    }
    
    func getMotive() -> SettingsColorMotive {
        SettingsColorMotive(rawValue: storage.getString(for: "Motive") ?? "") ?? .system
    }
    
    func setHelper(position: SettingsHelperPosition) {
        storage.set(value: position.rawValue, for: "Helper")
    }
    
    func getHelperPosition() -> SettingsHelperPosition {
        SettingsHelperPosition(rawValue: storage.getString(for: "Helper") ?? "") ?? .auto
    }
    
    /*
     Settings for:
     font size - small & stretch / large & 2 lines, font style
     */
}

enum SettingsColorMotive: String, CaseIterable {
    case system
    case matrix
    case retro
}

enum SettingsHelperPosition: String {
    case auto
    case top
    case bottom
}
