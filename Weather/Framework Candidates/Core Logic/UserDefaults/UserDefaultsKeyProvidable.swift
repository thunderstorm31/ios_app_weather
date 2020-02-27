public protocol UserDefaultsKey: Hashable {
    var storageKey: String { get }
}

extension UserDefaultsKey {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storageKey)
    }
}
