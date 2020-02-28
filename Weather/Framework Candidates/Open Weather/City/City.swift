import CoreGraphics
import CoreLocation

public struct City: Codable, Hashable {
    public let id: Int
    public let name: String
    public let countryCode: String
    public let coordinates: Coordinates
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let coordinatesContainer = try container.nestedContainer(keyedBy: CoordinatesCodingKeys.self, forKey: .coordinates)
//
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        countryCode = try container.decode(String.self, forKey: .countryCode)
//
//        let latitude = try coordinatesContainer.decode(CLLocationDegrees.self, forKey: .latitude)
//        let longitude = try coordinatesContainer.decode(CLLocationDegrees.self, forKey: .longitude)
//
//        location = CLLocation(latitude: latitude, longitude: longitude)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(countryCode, forKey: .countryCode)
//
//        var coordinatesContainer = container.nestedContainer(keyedBy: CoordinatesCodingKeys.self, forKey: .coordinates)
//
//        try coordinatesContainer.encode(location.coordinate.latitude, forKey: .latitude)
//        try coordinatesContainer.encode(location.coordinate.longitude, forKey: .longitude)
//    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, countryCode = "country", coordinates = "coord"
    }
    
//    private enum CoordinatesCodingKeys: String, CodingKey {
//        case latitude = "lat", longitude = "lon"
//    }
    
    public static func == (lhs: City, rhs: City) -> Bool { lhs.id == rhs.id }
}
