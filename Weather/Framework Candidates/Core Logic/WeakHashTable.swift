import Foundation

public final class WeakHashTable<T>: Sequence {
    private class WeakWrapper: Equatable {
        weak var value: AnyObject?

        init(_ value: AnyObject) {
            self.value = value
        }

        static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
            return lhs.value === rhs.value
        }
    }

    private var items: [WeakWrapper] = []
    private let lock = NSLock()

    public init() {
    }

    public var count: Int {
        lock.lock()

        defer {
            lock.unlock()
        }

        trimNilValues()

        return items.count
    }

    public func add(_ item: T) {
        lock.lock()

        defer {
            lock.unlock()
        }

        trimNilValues()

        guard items.contains(WeakWrapper(item as AnyObject)) == false else {
            return
        }

        items.append(WeakWrapper(item as AnyObject))
    }

    public func remove(_ item: T) {
        lock.lock()

        defer {
            lock.unlock()
        }

        trimNilValues()

        guard let index = items.firstIndex(where: { weakWrapper in
            return weakWrapper.value === item as AnyObject
        }) else {
            return
        }

        items.remove(at: index)
    }
    
    public func removeAll() {
        lock.lock()
        items.removeAll()
        lock.unlock()
    }

    public func contains(_ item: T) -> Bool {
        lock.lock()

        defer {
            lock.unlock()
        }

        trimNilValues()

        return items.contains(WeakWrapper(item as AnyObject))
    }

    public var allObjects: [T] {
        lock.lock()

        defer {
            lock.unlock()
        }

        return items.compactMap {
            $0.value as? T
        }
    }

    public func makeIterator() -> AnyIterator<T> {
        lock.lock()

        defer {
            lock.unlock()
        }

        trimNilValues()

        let allObjects = items.compactMap {
            $0.value as? T
        }

        var index = 0

        return AnyIterator {
            guard index < allObjects.count else {
                return nil
            }
            
            let value = allObjects[index]
            
            index += 1
            
            return value
        }
    }

    private func trimNilValues() {
        items = items.compactMap {
            $0.value == nil ? nil : $0
        }
    }
}
