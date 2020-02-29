import Foundation

public struct SunTimes: Hashable, Codable {
    public let sunrise: TimeInterval
    public let sunset: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}
