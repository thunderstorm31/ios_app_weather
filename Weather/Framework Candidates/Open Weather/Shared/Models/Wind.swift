import Foundation

public struct Wind: Hashable, Codable {
    public let speed: Double
    public let degree: Int
    
    private enum CodingKeys: String, CodingKey {
        case speed, degree = "deg"
    }
}
