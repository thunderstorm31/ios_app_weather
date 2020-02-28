extension Services {
    internal struct ServiceId: Hashable {
        internal let type: Any.Type

        internal init(type: Any.Type) {
            self.type = type
        }
        
        internal func hash(into hasher: inout Hasher) {
            let identifier = ObjectIdentifier(type)

            hasher.combine(identifier)
        }

        internal static func == (lhs: Services.ServiceId, rhs: Services.ServiceId) -> Bool {
            return lhs.type == rhs.type
        }
    }
}
