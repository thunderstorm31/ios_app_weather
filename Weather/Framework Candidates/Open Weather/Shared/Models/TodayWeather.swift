import Foundation

public struct TodayWeather: Hashable, Codable {
    public let id: Int
    public let base: String
    public let name: String
    
    public let coordinate: Coordinates
    public let dayTime: TimeInterval
    public let timezone: Int
    
    public let wind: Wind
    public let clouds: Clouds
    public let sunTimes: SunTimes
    
    public let weather: [Weather]
    public let weatherDetails: WeatherDetails
    
    private enum CodingKeys: String, CodingKey {
        case id, base, name, wind, clouds
        case coordinate = "coord", sunTimes = "sys"
        case weather, weatherDetails = "main"
        case dayTime = "dt", timezone
    }
}
