import Foundation

internal protocol PopupSettingsService: Service {
    var didDismissAddCurrentLocationPopup: Bool { get set }
}

internal final class PopupSettings {
    private let storage: StorageContainer<StorageKeys>
    
    internal init(storage: Storage = UserDefaults.standard) {
        self.storage = storage.storageContainer(for: StorageKeys.self)
    }
    
    private enum StorageKeys: String, UserDefaultsKey {
        case didDismissAddCurrentLocationPopup
        
        fileprivate var storageKey: String {
            "popupSettings.\(rawValue)"
        }
        
        fileprivate func hash(into hasher: inout Hasher) {
            hasher.combine(storageKey)
        }
    }
}

extension PopupSettings: PopupSettingsService {
    internal var didDismissAddCurrentLocationPopup: Bool {
        get { storage.bool(for: .didDismissAddCurrentLocationPopup) }
        set { storage.set(newValue, for: .didDismissAddCurrentLocationPopup) }
    }
}
