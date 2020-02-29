import Foundation
import CoreLocation

public struct TodayWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
}

public struct ForecastWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
}

public typealias TodayWeatherCompletion = ((TodayWeather?, Error?) -> Void)
public typealias ForecastWeatherCompletion = ((HourlyForecasts?, Error?) -> Void)

public protocol WeatherService: Service {
    func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion)
    func load(_ request: ForecastWeatherRequest, completion: @escaping ForecastWeatherCompletion)
}

public final class WeatherBll: WeatherService {
    private let dateFormatter = DateFormatter()
    
    public init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    public func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        DispatchTools.onBackground {
            guard let url = Bundle(for: WeatherBll.self).url(forResource: "TodayWeather", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                return assertionFailure("Could not find assets")
            }
            
            do {
                
                let weather = try decoder.decode(TodayWeather.self, from: data)
                
                DispatchTools.onMain(withDelay: 1) {
                    completion(weather, nil)
                }
            } catch {
                assertionFailure("Failed loading today weather \(error)")
                
                DispatchTools.onMain {
                    completion(nil, error)
                }
            }
        }
    }
    
    public func load(_ request: ForecastWeatherRequest, completion: @escaping ForecastWeatherCompletion) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        DispatchTools.onBackground {
            guard let url = Bundle(for: WeatherBll.self).url(forResource: "ForecastWeather", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                return assertionFailure("Could not find assets")
            }
            
            do {
                let forecastWeather = try decoder.decode(HourlyForecasts.self, from: data)
                
                DispatchTools.onMain(withDelay: 1) {
                    completion(forecastWeather, nil)
                }
            } catch {
                assertionFailure("Failed loading forecast weather \(error)")
                
                DispatchTools.onMain {
                    completion(nil, error)
                }
            }
        }
    }
}
