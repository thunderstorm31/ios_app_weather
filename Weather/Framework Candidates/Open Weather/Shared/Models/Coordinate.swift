import CoreLocation

public struct Coordinate: Hashable, Codable {
    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
