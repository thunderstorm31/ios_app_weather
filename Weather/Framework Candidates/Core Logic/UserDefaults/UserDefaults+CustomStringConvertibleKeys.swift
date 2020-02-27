import Foundation

extension UserDefaults {
    public func object(for key: CustomStringConvertible) -> Any? {
        return object(forKey: key.description)
    }
    
    public func set(_ value: Any?, key: CustomStringConvertible) {
        set(value, forKey: key.description)
    }
    
    public func removeObject(for key: CustomStringConvertible) {
        removeObject(forKey: key.description)
    }
    
    public func string(for key: CustomStringConvertible) -> String? {
        return string(forKey: key.description)
    }
    
    public func set(_ value: String?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func array(for key: CustomStringConvertible) -> [Any]? {
        return array(forKey: key.description)
    }
    
    public func set(_ value: [Any]?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func dictionary(for key: CustomStringConvertible) -> [String: Any]? {
        return dictionary(forKey: key.description)
    }
    
    public func set(_ value: [String: Any]?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func data(for key: CustomStringConvertible) -> Data? {
        return data(forKey: key.description)
    }
    
    public func set(_ value: Data?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func stringArray(for key: CustomStringConvertible) -> [String]? {
        return stringArray(forKey: key.description)
    }
    
    public func set(_ value: [String]?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func integer(for key: CustomStringConvertible) -> Int {
        return integer(forKey: key.description)
    }
    
    public func set(_ value: Int, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func float(for key: CustomStringConvertible) -> Float {
        return float(forKey: key.description)
    }
    
    public func set(_ value: Float, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func double(for key: CustomStringConvertible) -> Double {
        return double(forKey: key.description)
    }
    
    public func set(_ value: Double, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func bool(for key: CustomStringConvertible) -> Bool {
        return bool(forKey: key.description)
    }
    
    public func set(_ value: Bool, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
    
    public func url(for key: CustomStringConvertible) -> URL? {
        return url(forKey: key.description)
    }
    
    public func set(_ value: URL?, for key: CustomStringConvertible) {
        return set(value, forKey: key.description)
    }
}
