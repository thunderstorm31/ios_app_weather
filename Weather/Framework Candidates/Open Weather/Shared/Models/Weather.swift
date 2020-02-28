import Foundation

public struct Weather: Hashable, Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}
