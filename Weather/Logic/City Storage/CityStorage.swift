import Foundation

internal final class CityStorage {
    private let container: StorageContainer<StorageKeys>
    
    internal init(storage: Storage) {
        container = storage.storageContainer(for: StorageKeys.self)
    }
    
    internal var selectedCity: City? {
        set {
            if let newValue = newValue {
                container.setEncodable(newValue, for: .selectedCity)
            } else {
                container.removeObject(for: .selectedCity)
            }
        }
        get {
            let cities = self.cities
            
            if let city = container.decodable(ofType: City.self, for: .selectedCity), cities.contains(city) {
                return city
            } else {
                return cities.first
            }
        }
    }
    
    internal var cities: [City] {
        set { container.setEncodable(newValue, for: .cities) }
        get { container.decodable(ofType: [City].self, for: .cities) ?? [] }
    }
    
    @discardableResult
    internal func add(_ city: City) -> Bool {
        var cities = self.cities
        
        guard cities.contains(city) == false else {
            return false
        }
        
        cities.append(city)
        
        self.cities = cities
        
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
}

// MARK: - Storage and Legacy Keys
extension CityStorage {
    internal enum StorageKeys: String, UserDefaultsKey {
        case cities, selectedCity
        
        internal var storageKey: String {
            return "cities." + rawValue
        }
        
        internal func hash(into hasher: inout Hasher) {
            hasher.combine(storageKey)
        }
    }
}
