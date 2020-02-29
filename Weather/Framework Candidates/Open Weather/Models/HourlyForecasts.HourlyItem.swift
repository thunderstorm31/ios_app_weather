import Foundation

extension HourlyForecasts {
    public struct HourlyItem: Hashable, Codable, Comparable {
        public let timestamp: TimeInterval
        public let weather: [Weather]
        public let weatherDetails: WeatherDetails
        public let clouds: Clouds
        public let wind: Wind
        public let rain: Rain?
        public let date: Date
        
        private enum CodingKeys: String, CodingKey {
            case timestamp = "dt", weatherDetails = "main", weather
            case clouds, wind, rain, date = "dt_txt"
        }
        
        public static func < (lhs: HourlyForecasts.HourlyItem, rhs: HourlyForecasts.HourlyItem) -> Bool { lhs.date < rhs.date }
    }
}
