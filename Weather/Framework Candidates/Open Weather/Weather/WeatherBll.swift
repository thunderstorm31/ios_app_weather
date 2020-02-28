import Foundation
import CoreLocation

public struct TodayWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
}

public struct ForecastWeatherRequest {
    public let coordinate: CLLocationCoordinate2D
}

public typealias TodayWeatherCompletion = ((TodayWeather?, Error?) -> Void)
public typealias ForecastWeatherCompletion = ((ForecastWeather?, Error?) -> Void)

public protocol WeatherService: Service {
    func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion)
    func load(_ request: ForecastWeatherRequest, completion: @escaping ForecastWeatherCompletion)
}

public final class WeatherBll: WeatherService {
    public func load(_ request: TodayWeatherRequest, completion: @escaping TodayWeatherCompletion) {
        DispatchTools.onBackground {
            guard let url = Bundle(for: WeatherBll.self).url(forResource: "TodayWeather", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                return assertionFailure("Could not find assets")
            }
            
            do {
                let weather = try JSONDecoder().decode(TodayWeather.self, from: data)
                
                DispatchTools.onMain(withDelay: 3) {
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
        DispatchTools.onBackground {
            guard let url = Bundle(for: WeatherBll.self).url(forResource: "ForecastWeather", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                return assertionFailure("Could not find assets")
            }
            
            do {
                let forecastWeather = try JSONDecoder().decode(ForecastWeather.self, from: data)
                
                DispatchTools.onMain(withDelay: 3) {
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
