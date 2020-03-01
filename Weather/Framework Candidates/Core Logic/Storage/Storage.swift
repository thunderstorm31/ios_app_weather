import Foundation

public protocol Storage: AnyObject {
    func set(_ value: Any?, forKey key: String)
    func set(_ value: Int, forKey key: String)
    func set(_ value: Float, forKey key: String)
    func set(_ value: Double, forKey key: String)
    func set(_ value: Bool, forKey key: String)
    
    func removeObject(forKey key: String)
    
    func object(forKey key: String) -> Any?
    func string(forKey key: String) -> String?
    func integer(forKey key: String) -> Int
    func float(forKey key: String) -> Float
    func double(forKey key: String) -> Double
    func bool(forKey key: String) -> Bool
}

extension Storage {
    public func storageContainer<T: UserDefaultsKey>(for type: T.Type) -> StorageContainer<T> {
        StorageContainer(storage: self)
    }
    
    public func object<T>(ofType: T.Type, forKey key: String) -> T? {
        guard let object = self.object(forKey: key) else {
            return nil
        }
        
        guard let result = object as? T else {
            return nil
        }
        
        return result
    }
}

extension UserDefaults: Storage {}
