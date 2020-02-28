import Foundation

public struct ForecastWeather: Hashable, Codable {
    public let message: Int
    public let hourlyForecasts: [HourlyForecast]
    
    private enum CodingKeys: String, CodingKey {
        case message, hourlyForecasts = "list"
    }
}
