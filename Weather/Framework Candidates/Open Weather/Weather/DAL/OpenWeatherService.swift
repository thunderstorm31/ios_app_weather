import Foundation

public typealias OpenWeatherServiceRequestCompletion = (Data?, URLResponse?, Error?) -> Void

public protocol OpenWeatherService: Service {
    func get(endpoint: OpenWeatherServiceEndpoint, query: [URLQueryItem], completion: @escaping OpenWeatherServiceRequestCompletion)
}

public enum OpenWeatherServiceEndpoint: String {
    case currentWeather = "weather"
    case forecast = "forecast"
}

extension OpenWeatherService {
    internal func get<T: Codable>(endpoint: OpenWeatherServiceEndpoint,
                                  query: [URLQueryItem],
                                  as type: T.Type,
                                  dateFormatter: DateFormatter,
                                  completion: @escaping (T?, URLResponse?, Error?) -> Void) {
        get(endpoint: endpoint, query: query) { data, response, error in
            guard let data = data else {
                completion(nil, response, error)
                return
            }
        
            DispatchTools.onBackground {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    let result = try decoder.decode(T.self, from: data)
                    
                    DispatchTools.onMain {
                        completion(result, response, error)
                    }
                } catch {
                    DispatchTools.onMain {
                        completion(nil, nil, error)
                    }
                }
            }
        }
    }
}
