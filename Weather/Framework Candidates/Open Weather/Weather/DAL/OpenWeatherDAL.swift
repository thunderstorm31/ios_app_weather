import Foundation

public final class OpenWeatherDAL: OpenWeatherService {
    public let host: String
    public let appId: String
    
    private let urlSession = URLSession.shared
    
    public init(host: String = "https://api.openweathermap.org/data/2.5/", appId: String) {
        self.host = host
        self.appId = appId
    }
    
    public func get(endpoint: OpenWeatherServiceEndpoint, query: [URLQueryItem], completion: @escaping OpenWeatherServiceRequestCompletion) {
        var components = URLComponents(string: host + "\(endpoint.rawValue)/")
        
        var queryItems = query
        
        queryItems.append(URLQueryItem(name: "appid", value: appId))
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            assertionFailure("Could not construct url for endpoint \(endpoint) with query items: \(query)")
            
            DispatchTools.onMain {
                completion(nil, nil, nil)
            }
            
            return
        }
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            DispatchTools.onMain {
                completion(data, response, error)
            }
        }
        
        task.resume()
    }
}
