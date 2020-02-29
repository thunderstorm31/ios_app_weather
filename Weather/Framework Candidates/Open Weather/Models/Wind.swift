import Foundation

public struct Wind: Hashable, Codable {
    public let speed: Double
    public let degree: Int
    
    private enum CodingKeys: String, CodingKey {
        case speed, degree = "deg"
    }
    
    public var windDirection: WindDirectionAbbreviation {
        switch Double(degree) {
        case 11.251..<33.751: return .NNE
        case 33.751..<56.251: return .NE
        case 56.251..<78.751: return .ENE
        case 78.751..<101.251: return .E
        case 101.251..<123.751: return .ESE
        case 123.751..<146.251: return .SE
        case 146.251..<168.751: return .SSE
        case 168.751..<191.251: return .S
        case 191.251..<213.751: return .SSW
        case 213.751..<236.251: return .SW
        case 236.251..<258.751: return .WSW
        case 258.751..<281.251: return .W
        case 281.251..<303.751: return .WNW
        case 303.751..<326.251: return .NW
        case 326.251..<348.751: return .NNW
        default: return .N
        }
    }
    
    public enum WindDirectionAbbreviation: String {
        case N
        case NNE
        case NE
        case ENE
        case E
        case ESE
        case SE
        case SSE
        case S
        case SSW
        case SW
        case WSW
        case W
        case WNW
        case NW
        case NNW
    }
}
