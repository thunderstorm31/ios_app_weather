import Foundation

public struct TodayWeather: Hashable, Codable {
    public let id: Int
    public let base: String
    public let name: String
    
    public let coordinate: Coordinate
    public let dayTime: TimeInterval
    public let timezone: Int
    
    public let wind: Wind
    public let clouds: Clouds
    public let sunTimes: SunTimes
    
    public let weather: [Weather]
    public let todayWeather: DailyWeather
    
    public enum CodingKeys: String, CodingKey {
        case id, base, name, wind, clouds
        case coordinate = "coord", sunTimes = "sys"
        case weather, todayWeather = "main"
        case dayTime = "dt", timezone
    }
}
