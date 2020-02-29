import Foundation
import CoreLocation

public struct TodayWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
    public let unitSystem: String?
}

public struct ForecastWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
    public let unitSystem: String?
}

public typealias TodayWeatherCompletion = ((TodayWeather?, Error?) -> Void)
public typealias ForecastWeatherCompletion = ((HourlyForecasts?, Error?) -> Void)

public protocol WeatherService: Service {
    func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion)
    func load(_ request: ForecastWeatherRequest, completion: @escaping ForecastWeatherCompletion)
}

public final class WeatherBll: WeatherService {
    private let dateFormatter = DateFormatter()
    
    private let services: Services
    private var openWeatherService: OpenWeatherService { services.get(OpenWeatherService.self) }
    
    public init(services: Services = .default) {
        self.services = services
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    public func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion) {
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "lat", value: "\(request.coordinate.latitude)"))
        queryItems.append(URLQueryItem(name: "lon", value: "\(request.coordinate.longitude)"))
        
        if let unitSystem = request.unitSystem {
            queryItems.append(URLQueryItem(name: "units", value: unitSystem))
        }
        
        openWeatherService.get(endpoint: .currentWeather,
                               query: queryItems,
                               as: TodayWeather.self,
                               dateFormatter: dateFormatter) { weather, _, error in
                                completion(weather, error)
        }
    }
    
    public func load(_ request: ForecastWeatherRequest, completion: @escaping ForecastWeatherCompletion) {
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "lat", value: "\(request.coordinate.latitude)"))
        queryItems.append(URLQueryItem(name: "lon", value: "\(request.coordinate.longitude)"))
        
        if let unitSystem = request.unitSystem {
            queryItems.append(URLQueryItem(name: "units", value: unitSystem))
        }
        
        openWeatherService.get(endpoint: .forecast,
                               query: queryItems,
                               as: HourlyForecasts.self,
                               dateFormatter: dateFormatter) { forecast, _, error in
                                completion(forecast, error)
        }
    }
}
