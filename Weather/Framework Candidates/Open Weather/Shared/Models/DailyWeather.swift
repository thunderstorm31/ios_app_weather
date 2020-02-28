import Foundation

public struct DailyWeather: Hashable, Codable {
    public let temperature: Double
    public let feelsLike: Double
    public let temperatureMinimum: Double
    public let temperatureMaximum: Double
    
    public let humidity: Int
    
    public let pressure: Int
    public let pressureSeaLevel: Int
    public let pressureGroundLevel: Int
    
    public enum CodingKeys: String, CodingKey {
        case temperature = "temp", feelsLike = "feels_like", temperatureMinimum = "temp_min", temperatureMaximum = "temp_max"
        case pressure, humidity, pressureSeaLevel = "sea_level", pressureGroundLevel = "grnd_level"
    }
}
