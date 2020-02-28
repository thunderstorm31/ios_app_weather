import Foundation

public final class Services {
    public typealias Factory<T> = ((_ services: Services) throws -> T) where T: Service

    private struct InstanceFactory {
        fileprivate var factory: ((_ services: Services) throws -> Any)
    }

    private struct RegisteredServiceType {
        private var _preferredType: ServiceId?

        fileprivate var instanceTypes: [ServiceId]
        fileprivate var preferredType: ServiceId {
            get {
                return _preferredType ?? instanceTypes[instanceTypes.count - 1]
            }
            set {
                _preferredType = newValue
            }
        }

        fileprivate init(instanceType: ServiceId) {
            instanceTypes = [instanceType]
        }
    }

    private struct State {
       fileprivate var instanceFactories: [ServiceId: InstanceFactory] = [:]
       fileprivate var registeredTypes: [ServiceId: RegisteredServiceType] = [:]
       fileprivate var instanceCache: [ServiceId: CacheItem] = [:]
    }

    private struct CacheItem {
        fileprivate let instance: Any
    }

    public static let `default` = Services()

    private var currentState = State()

    private var stateStack: [State] = []

    private let lock = NSLock()

    public init() {}
    
    // MARK: - Register Services

    public func register<T>(forType type: Any.Type, factory: @escaping Factory<T>) throws where T: Service {
        try register(forTypes: [type], factory: factory)
    }

    public func register<T>(forTypes types: [Any.Type], factory: @escaping Factory<T>) throws where T: Service {
        lock.lock()

        defer {
            lock.unlock()
        }

        let instanceServiceId = ServiceId(type: T.self)

        for type in types {
            let serviceId = ServiceId(type: type)

            if var registeredType = currentState.registeredTypes[serviceId] {
                guard registeredType.instanceTypes.contains(instanceServiceId) == false else {
                    throw ServicesError(reason: "The service type \(type) already has instance type \(T.self) registered.",
                                        possibleCauses: ["The same instance type is registered for the same service type at multiple locations"],
                                        suggestedFixes: ["Remove one of the registration calls"])
                }

                registeredType.instanceTypes.append(instanceServiceId)

                currentState.registeredTypes[serviceId] = registeredType
            } else {
                currentState.registeredTypes[serviceId] = RegisteredServiceType(instanceType: instanceServiceId)
            }
        }

        currentState.instanceFactories[.init(type: T.self)] = InstanceFactory(factory: factory)
    }

    public func register<T>(_: T.Type, forType type: Any.Type) throws where T: InitializableService {
        try register(T.self, forTypes: [type])
    }

    public func register<T>(_: T.Type, forTypes types: [Any.Type]) throws where T: InitializableService {
        try register(forTypes: types) { services in
            return T(services: services)
        }
    }

    public func register<T>(_ instance: T, forType type: Any.Type) throws where T: Service {
        try register(instance, forTypes: [type])
    }

    public func register<T>(_ instance: T, forTypes types: [Any.Type]) throws where T: Service {
        try register(forTypes: types) { _ in
            instance
        }
    }

    public func register(_ provider: ServiceProvider) throws {
        try provider.register(services: self)
    }
    
    // MARK: - Get Services

    public func get<T>(_ type: T.Type = T.self) -> T {
        do {
            return try safeGet(T.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func safeGet<T>(_ type: T.Type = T.self) throws -> T {
        lock.lock()

        defer {
            lock.unlock()
        }

        return try resolve(T.self)
    }
    
    // MARK: - Removing and resetting
    
    public func unregisterAllServices() {
        lock.lock()

        defer {
            lock.unlock()
        }
        
        currentState.instanceFactories.removeAll()
        currentState.registeredTypes.removeAll()
        currentState.instanceCache.removeAll()
    }
    
    // MARK: - Misc

    public func prefer<T>(_: T.Type, forType type: Any.Type) throws where T: Service {
        lock.lock()

        defer {
            lock.unlock()
        }

        let serviceId = ServiceId(type: type)
        let instanceServiceId = ServiceId(type: T.self)

        guard var registeredType = currentState.registeredTypes[serviceId] else {
            throw ServicesError(reason: "Setting a preferred instance for an unknown type",
                                possibleCauses: ["The type \(type) is unknown"],
                                suggestedFixes: ["Make sure the service is properly registered before setting it as a preference"])
        }

        guard registeredType.instanceTypes.contains(instanceServiceId) else {
            throw ServicesError(reason: "Setting an unknown service for type \(type)",
                                possibleCauses: ["The service \(T.self) is not registered for type \(type)"],
                                suggestedFixes: ["Make sure the service is properly registered before setting it as a preference"])
        }

        registeredType.preferredType = instanceServiceId

        currentState.registeredTypes[serviceId] = registeredType
    }

    public func pushState() {
        lock.lock()

        defer {
            lock.unlock()
        }

        stateStack.append(currentState)
    }

    public func popState() {
        lock.lock()

        defer {
            lock.unlock()
        }

        guard let state = stateStack.popLast() else {
            assertionFailure("Pop state is called on an empty state stack")

            return
        }

        currentState = state
    }

    public func forceInstance<T>(_ instance: T, forType type: Any.Type) throws where T: Service {
        lock.lock()

        let serviceId = ServiceId(type: type)
        let instanceServiceId = ServiceId(type: T.self)

        if var registeredType = currentState.registeredTypes[serviceId] {
            if let index = registeredType.instanceTypes.firstIndex(of: instanceServiceId) {
                registeredType.instanceTypes.remove(at: index)

                currentState.registeredTypes[serviceId] = registeredType
            }
        }

        currentState.instanceCache.removeValue(forKey: instanceServiceId)
        currentState.instanceFactories.removeValue(forKey: .init(type: T.self))

        lock.unlock()

        try register(instance, forType: type)
        try prefer(T.self, forType: type)
    }

    private func resolve<T>(_ type: T.Type) throws -> T {
        guard let matchingType = currentState.registeredTypes[.init(type: T.self)] else {
            throw ServicesError(reason: "Unable to get service.",
                                possibleCauses: ["No service is registered for type \(T.self)"],
                                suggestedFixes: ["Register a service for type \(T.self)"])
        }

        let resolvedServiceId = matchingType.preferredType

        if let cachedInstance = currentState.instanceCache[resolvedServiceId]?.instance as? T {
            return cachedInstance
        }

        let instance = try currentState.instanceFactories[resolvedServiceId]?.factory(self)

        guard let castInstance = instance as? T else {
            throw ServicesError(reason: "Failed to cast instance of \(resolvedServiceId.type) to service type \(T.self)",
                                possibleCauses: [
                                    "The registered service \(resolvedServiceId.type) does not implement type \(T.self)"
                                ],
                                suggestedFixes: [
                                    "Register the correct service for type \(T.self)",
                                    "Implement the type on the service"
                                ])
        }

        currentState.instanceCache[resolvedServiceId] = CacheItem(instance: castInstance)

        return castInstance
    }

    private func preferredRegisteredServiceType<T>(for type: T.Type, matchingType: RegisteredServiceType) throws -> ServiceId {
        return matchingType.preferredType
    }

    private func cachedInstance<T>(for instanceType: Any.Type, serviceType: T.Type) -> T? {
        return currentState.instanceCache[.init(type: instanceType)]?.instance as? T
    }
}

extension Services: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "Services instance with \(self.currentState.registeredTypes.count) types registered."
    }

    public var debugDescription: String {
        func list(_ items: [ServiceId]) -> String {
            return items.map { "\($0.type)" }.joined(separator: ", ")
        }

        var text = "Services instance with the following service types registered:\n"

        text += currentState.registeredTypes.map { serviceId, registeredType in
            return " - \(serviceId.type) with instance types [\(list(registeredType.instanceTypes))], the preferred type is \(registeredType.preferredType.type)"
        }.joined(separator: "\n")

        text += "\nThe following instances have been initialized:\n"

        text += currentState.instanceCache.map { serviceId, _ in
            return " - \(serviceId.type)"
        }.joined(separator: "\n")

        return text
    }
}
