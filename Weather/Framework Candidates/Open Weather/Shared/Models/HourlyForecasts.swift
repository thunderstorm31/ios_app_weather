import Foundation

public struct HourlyForecasts: Hashable, Codable {
    public let message: Int
    public let hourlyForecasts: [HourlyItem]
    
    public private(set) lazy var dayItems: [DayItem] = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var items: [String: [HourlyItem]] = [:]
        
        hourlyForecasts.forEach { hourlyItem in
            let dateString = dateFormatter.string(from: hourlyItem.date)
            
            var hourlyItems = items[dateString] ?? []
            
            hourlyItems.append(hourlyItem)
            
            items[dateString] = hourlyItems
        }
        
        let dayItems = items.compactMap { dateString, hourlyItems -> DayItem? in
            guard let date = dateFormatter.date(from: dateString) else {
                return nil
            }
                        
            return DayItem(date: date, hourlyItems: hourlyItems.sorted(by: <))
        }.sorted(by: <)

        return dayItems
    }()
    
    private enum CodingKeys: String, CodingKey {
        case message, hourlyForecasts = "list"
    }
}
