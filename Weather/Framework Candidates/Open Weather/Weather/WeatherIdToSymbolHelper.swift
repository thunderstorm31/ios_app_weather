public final class WeatherIdToSymbolHelper {
    public static func symbolName(for id: Int, isDayTime: Bool) -> String {
        if (200..<300).contains(id) {
            return thunderStormSymbolName(for: id, isDayTime: isDayTime)
        } else if (300..<400).contains(id) {
            return "cloud.drizzle"
        } else if (500..<600).contains(id) {
            return rainSymbolName(for: id, isDayTime: isDayTime)
        } else if (600..<700).contains(id) {
            return "snow"
        } else if (700..<800).contains(id) {
            return specialSymbolNames(for: id, isDayTime: isDayTime)
        } else if id == 800 {
            return isDayTime ? "sun.max" : "moon"
        } else if (801..<900).contains(id) {
            return cloudSymbolNames(for: id, isDayTime: isDayTime)
        }
        
        return "questionmark"
    }
    
    private static func thunderStormSymbolName(for id: Int, isDayTime: Bool) -> String {
        switch id {
        case 200, 201:
            return isDayTime ? "cloud.sun.bolt" : "cloud.moon.bolt"
        case 202, 212, 232:
            return "cloud.bolt.rain"
        default:
            return isDayTime ? "cloud.sun.bolt" : "cloud.moon.bolt"
        }
    }
    
    private static func rainSymbolName(for id: Int, isDayTime: Bool) -> String {
        switch id {
        case 500:
            return isDayTime ? "cloud.sun.rain" : "cloud.moon.rain"
        case 501:
            return "cloud.heavyrain"
        case 502, 503, 504:
            return "cloud.heavyrain"
        case 511:
            return "snow"
        case 520, 521, 522, 531:
            return "cloud.drizzle"
        default:
            return "cloud.rain"
        }
    }
    
    private static func specialSymbolNames(for id: Int, isDayTime: Bool) -> String {
        switch id {
        case 701, 741, 771:
            return "cloud.fog"
        case 711, 762:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731, 761:
            return "sun.dust"
        case 781:
            return "tornado"
        default:
            return "cloud.fog"
        }
    }
    
    private static func cloudSymbolNames(for id: Int, isDayTime: Bool) -> String {
        switch id {
        case 801:
            return isDayTime ? "cloud.sun" : "cloud.moon"
        case 802:
            return "cloud"
        case 803, 804:
            return "cloud.fill"
        default:
            return "cloud"
        }
    }
}
