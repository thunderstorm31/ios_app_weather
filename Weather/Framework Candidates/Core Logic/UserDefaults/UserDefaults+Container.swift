import Foundation

extension UserDefaults {
    public class Container<T: UserDefaultsKey> {
        fileprivate let userDefaults: UserDefaults
        
        fileprivate init(userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }
    }
}

extension UserDefaults.Container {
    public func object(for key: T) -> Any? {
        return userDefaults.object(forKey: key.storageKey)
    }
    
    public func set(_ object: Any?, key: T) {
        userDefaults.set(object, forKey: key.storageKey)
    }
    
    public func removeObject(for key: T) {
        userDefaults.removeObject(forKey: key.storageKey)
    }
    
    public func string(for key: T) -> String? {
        return userDefaults.string(forKey: key.storageKey)
    }
    
    public func object<U>(for key: T, of type: U.Type) -> U? {
        guard let object = userDefaults.object(forKey: key.storageKey) else {
            return nil
        }
        
        guard let castedObject = object as? U else {
            assertionFailure("Object should be of type: \(type)")
            return nil
        }
        
        return castedObject
    }
    
    public func object<U>(for key: T, of type: U.Type, default defaultValue: @autoclosure () -> U) -> U {
        guard let object = userDefaults.object(forKey: key.storageKey) else {
            return defaultValue()
        }
        
        guard let castedObject = object as? U else {
            assertionFailure("Object should be of type: \(type)")
            return defaultValue()
        }
        
        return castedObject
    }
    
    public func array<U>(for key: T, of types: U.Type) -> [U]? {
        guard let object = userDefaults.object(forKey: key.storageKey) else {
            return nil
        }
        
        guard let castedObject = object as? [U] else {
            assertionFailure("Object should be of type: \(types)")
            return nil
        }
        
        return castedObject
    }
    
    public func array<U>(for key: T, of types: U.Type, default defaultValue: @autoclosure () -> [U]) -> [U] {
        guard let object = userDefaults.object(forKey: key.storageKey) else {
            return defaultValue()
        }
        
        guard let castedObject = object as? [U] else {
            assertionFailure("Object should be of type: \(types)")
            return defaultValue()
        }
        
        return castedObject
    }
    
    public func integer(for key: T) -> Int {
        return userDefaults.integer(forKey: key.storageKey)
    }
    
    public func set(_ integer: Int, for key: T) {
        userDefaults.set(integer, forKey: key.storageKey)
    }
    
    public func float(for key: T) -> Float {
        return userDefaults.float(forKey: key.storageKey)
    }
    
    public func set(_ float: Float, for key: T) {
        userDefaults.set(float, forKey: key.storageKey)
    }
    
    public func double(for key: T) -> Double {
        return userDefaults.double(forKey: key.storageKey)
    }
    
    public func set(_ double: Double, for key: T) {
        userDefaults.set(double, forKey: key.storageKey)
    }
    
    public func bool(for key: T) -> Bool {
        return userDefaults.bool(forKey: key.storageKey)
    }
    
    public func set(_ bool: Bool, for key: T) {
        userDefaults.set(bool, forKey: key.storageKey)
    }
    
    public func encode<U: Encodable>(_ value: U, for key: T) {
        userDefaults.encode(value, forKey: key.storageKey)
    }
    
    public func decode<U: Decodable>(_ type: U.Type, for key: T) -> U? {
        return userDefaults.decode(type, forKey: key.storageKey)
    }
}

extension UserDefaults {
    public static func defaultContainer<T: UserDefaultsKey>(type: T.Type) -> Container<T> {
        return UserDefaults.standard.container(for: type)
    }
    
    public static func container<T: UserDefaultsKey>(suiteName: String, type: T.Type) -> Container<T>? {
        return UserDefaults(suiteName: suiteName)?.container(for: type)
    }
    
    public func container<T: UserDefaultsKey>(for type: T.Type) -> Container<T> {
        return Container(userDefaults: self)
    }
}
