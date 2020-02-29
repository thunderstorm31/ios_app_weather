import Foundation

extension HourlyForecasts {
    public struct DayItem: Hashable, Comparable {
        public let date: Date
        public let hourlyItems: [HourlyItem]
        
        public var temperatureMinimum: Double? {
            guard hourlyItems.isNotEmpty else {
                return nil
            }
            
            return hourlyItems.reduce(hourlyItems[0].weatherDetails.temperatureMinimum) { (input, item) -> Double in
                min(input, item.weatherDetails.temperatureMinimum)
            }
        }
        
        public var temperatureMaximum: Double? {
            guard hourlyItems.isNotEmpty else {
                return nil
            }
            
            return hourlyItems.reduce(hourlyItems[0].weatherDetails.temperatureMaximum) { (input, item) -> Double in
                max(input, item.weatherDetails.temperatureMaximum)
            }
        }
        
        public static func < (lhs: HourlyForecasts.DayItem, rhs: HourlyForecasts.DayItem) -> Bool { lhs.date < rhs.date }
    }
}
