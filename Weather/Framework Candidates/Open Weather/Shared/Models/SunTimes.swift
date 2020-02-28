import Foundation

public struct SunTimes: Hashable, Codable {
    public let sunrise: TimeInterval
    public let sunset: TimeInterval
    
    public enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}
