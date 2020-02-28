import Foundation

extension ForecastWeather {
    public struct HourlyForecast: Hashable, Codable {
        public let daystamp: TimeInterval
        public let weather: [Weather]
        public let weatherDetails: WeatherDetails
        public let clouds: Clouds
        public let wind: Wind
        public let dateText: String
        
        private enum CodingKeys: String, CodingKey {
            case daystamp = "dt", weatherDetails = "main", weather
            case clouds, wind, dateText = "dt_txt"
        }
    }
}
