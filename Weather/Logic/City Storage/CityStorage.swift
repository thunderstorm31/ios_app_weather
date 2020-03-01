import Foundation

internal protocol CityStorageServiceDelegate: AnyObject {
    func cityStorageService(_ service: CityStorage, updatedStoredCities cities: [City])
    func cityStorageService(_ service: CityStorage, added: City, origin: CityStorageAddCityOrigin)
}

internal enum CityStorageAddCityOrigin {
    case map, search
}

extension CityStorageServiceDelegate {
    internal func cityStorageService(_ service: CityStorage, updatedStoredCities cities: [City]) {}
    internal func cityStorageService(_ service: CityStorage, added: City, origin: CityStorageAddCityOrigin) {}
}

internal protocol CityStorageService: Service {
    var cities: [City] { get set }
    
    @discardableResult
    func add(_ city: City, origin: CityStorageAddCityOrigin) -> Bool
    
    @discardableResult
    func remove(_ city: City) -> Bool
    
    @discardableResult
    func remove(cityAtIndex index: Int) -> Bool
    
    func addDelegate(_ delegate: CityStorageServiceDelegate)
    func removeDelegate(_ delegate: CityStorageServiceDelegate)
}

internal final class CityStorage: CityStorageService {
    private let container: StorageContainer<StorageKeys>
    private let delegates = WeakHashTable<CityStorageServiceDelegate>()
    
    internal init(storage: Storage = UserDefaults.standard) {
        container = storage.storageContainer(for: StorageKeys.self)
    }
    
    internal var cities: [City] {
        set {
            container.setEncodable(newValue, for: .cities)
            
            delegates.forEach { $0.cityStorageService(self, updatedStoredCities: newValue) }
        }
        get { container.decodable(ofType: [City].self, for: .cities) ?? [] }
    }
    
    @discardableResult
    internal func add(_ city: City, origin: CityStorageAddCityOrigin) -> Bool {
        var cities = self.cities
        
        guard cities.contains(city) == false else {
            return false
        }
        
        cities.append(city)
        
        self.cities = cities
        
        delegates.forEach { $0.cityStorageService(self, added: city, origin: origin) }
        
        return true
    }
    
    internal func remove(_ city: City) -> Bool {
        guard let index = cities.firstIndex(of: city) else {
            return false
        }
        
        return remove(cityAtIndex: index)
    }
    
    internal func remove(cityAtIndex index: Int) -> Bool {
        var cities = self.cities
        
        guard cities.indices.contains(index) else {
            return false
        }
        
        cities.remove(at: index)
        
        self.cities = cities
        
        return true
    }
    
    internal func addDelegate(_ delegate: CityStorageServiceDelegate) {
        delegates.add(delegate)
    }
    
    internal func removeDelegate(_ delegate: CityStorageServiceDelegate) {
        delegates.remove(delegate)
    }
}

// MARK: - Storage and Legacy Keys
extension CityStorage {
    internal enum StorageKeys: String, UserDefaultsKey {
        case cities
        
        internal var storageKey: String {
            return "cities." + rawValue
        }
        
        internal func hash(into hasher: inout Hasher) {
            hasher.combine(storageKey)
        }
    }
}
