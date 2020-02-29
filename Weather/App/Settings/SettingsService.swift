import Foundation

internal enum UnitSystem: String, Codable {
    case metric, imperial
    
    internal var openWeatherRequestValue: String {
        switch self {
        case .imperial: return "imperial"
        case .metric: return "metric"
        }
    }
    
    internal var localizedSpeedAbbreviation: String {
        switch self {
        case .imperial: return Localization.UnitSystem.milesPerHourAbbreviation
        case .metric: return Localization.UnitSystem.kilometersPerHourAbbreviation
        }
    }
    
    internal var localizedDistanceAbbreviation: String {
        switch self {
        case .imperial: return Localization.UnitSystem.milesAbbreviation
        case .metric: return Localization.UnitSystem.kilometersAbbreviation
        }
    }
}

internal protocol SettingsService: Service {
    var unitSystem: UnitSystem { get set }
}

internal final class Settings {
    private let storage: StorageContainer<StorageKeys>
    
    internal init(storage: Storage = UserDefaults.standard) {
        self.storage = storage.storageContainer(for: StorageKeys.self)
    }
    
    private enum StorageKeys: String, UserDefaultsKey {
        case unitSystem
        
        fileprivate var storageKey: String {
            "general.\(rawValue)"
        }
        
        fileprivate func hash(into hasher: inout Hasher) {
            hasher.combine(storageKey)
        }
    }
}

extension Settings: SettingsService {
    internal var unitSystem: UnitSystem {
        get {
            guard let value = storage.string(for: .unitSystem), let unit = UnitSystem(rawValue: value) else {
                return .metric
            }
            
            return unit
        }
        set {
            storage.set(newValue.rawValue, key: .unitSystem)
        }
    }
}
