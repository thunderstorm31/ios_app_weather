import Foundation

internal protocol SettingsService: Service {
    var unitSystem: String { get set }
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
    internal var unitSystem: String {
        get {
            guard let value = storage.string(for: .unitSystem) else {
                return "metric"
            }
            
            return value
        }
        set {
            storage.set(newValue, key: .unitSystem)
        }
    }
}
