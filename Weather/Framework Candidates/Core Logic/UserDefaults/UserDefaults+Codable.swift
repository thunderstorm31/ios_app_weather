import Foundation

extension UserDefaults {
    public func encode<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = value.encode() else {
            return
        }

        set(data, forKey: key)
    }

    public func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }

        return data.decode(type: T.self)
    }
}
