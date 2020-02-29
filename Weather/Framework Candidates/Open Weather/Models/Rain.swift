import Foundation

public struct Rain: Hashable, Codable {
    public let lastHour: Double?
    public let last3Hours: Double?
    
    public enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
        case last3Hours = "3h"
    }
}
