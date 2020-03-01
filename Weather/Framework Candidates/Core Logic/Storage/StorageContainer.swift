import Foundation

public final class StorageContainer<T: UserDefaultsKey> {
    public let storage: Storage
    
    public init(storage: Storage) {
        self.storage = storage
    }
}

extension StorageContainer {
    public func object(for key: T) -> Any? {
        storage.object(forKey: key.storageKey)
    }
    
    public func set(_ object: Any?, key: T) {
        storage.set(object, forKey: key.storageKey)
    }
    
    public func removeObject(for key: T) {
        storage.removeObject(forKey: key.storageKey)
    }
    
    public func string(for key: T) -> String? {
        storage.string(forKey: key.storageKey)
    }
    
    public func object<U>(for key: T, of type: U.Type) -> U? {
        guard let object = storage.object(forKey: key.storageKey) else {
            return nil
        }
        
        guard let castedObject = object as? U else {
            assertionFailure("Object should be of type: \(type)")
            return nil
        }
        
        return castedObject
    }
    
    public func object<U>(for key: T, of type: U.Type, default defaultValue: @autoclosure () -> U) -> U {
        guard let object = storage.object(forKey: key.storageKey) else {
            return defaultValue()
        }
        
        guard let castedObject = object as? U else {
            assertionFailure("Object should be of type: \(type)")
            return defaultValue()
        }
        
        return castedObject
    }
    
    public func array<U>(for key: T, of types: U.Type) -> [U]? {
        guard let object = storage.object(forKey: key.storageKey) else {
            return nil
        }
        
        guard let castedObject = object as? [U] else {
            assertionFailure("Object should be of type: \(types)")
            return nil
        }
        
        return castedObject
    }

    public func array<U>(for key: T, of types: U.Type, default defaultValue: @autoclosure () -> [U]) -> [U] {
        guard let object = storage.object(forKey: key.storageKey) else {
            return defaultValue()
        }
        
        guard let castedObject = object as? [U] else {
            assertionFailure("Object should be of type: \(types)")
            return defaultValue()
        }
        
        return castedObject
    }
    
    public func integer(for key: T) -> Int {
        storage.integer(forKey: key.storageKey)
    }
    
    public func set(_ integer: Int, for key: T) {
        storage.set(integer, forKey: key.storageKey)
    }
    
    public func set(_ string: String, for key: T) {
        storage.set(string, forKey: key.storageKey)
    }
    
    public func float(for key: T) -> Float {
        storage.float(forKey: key.storageKey)
    }
    
    public func set(_ float: Float, for key: T) {
        storage.set(float, forKey: key.storageKey)
    }
    
    public func double(for key: T) -> Double {
        storage.double(forKey: key.storageKey)
    }
    
    public func set(_ double: Double, for key: T) {
        storage.set(double, forKey: key.storageKey)
    }
    
    public func bool(for key: T) -> Bool {
        storage.bool(forKey: key.storageKey)
    }
    
    public func set(_ bool: Bool, for key: T) {
        storage.set(bool, forKey: key.storageKey)
    }
    
    public func setEncodable<U: Encodable>(_ value: U, for key: T) {
        guard let data = value.encode() else {
            return
        }
        
        set(data, key: key)
    }
    
    public func decodable<U: Decodable>(ofType type: U.Type, for key: T) -> U? {
        guard let data = object(for: key, of: Data.self) else {
            return nil
        }
        
        if let result = data.decode(type: U.self) {
            return result
        } else {
            return nil
        }
    }
}
