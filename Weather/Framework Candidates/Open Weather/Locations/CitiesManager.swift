import Foundation
import CoreLocation

public protocol CitiesService: Service {
    var isReady: Bool { get }
    
    func citiesFor(_ request: CityLocationRequest, completion: @escaping (([City]) -> Void))
    func citiesFor(_ request: CitySearchQueryRequest, completion: @escaping (([City]) -> Void))
}

public struct CityLocationRequest {
    public let coordinate: CLLocationCoordinate2D
    
    /// Zero or negative will result in all the results being returend
    public let limit: Int
    
    public let maxDistance: CLLocationDistance
    
    internal init(coordinate: CLLocationCoordinate2D, limit: Int = 1, maxDistance: CLLocationDistance = 1_500) {
        self.coordinate = coordinate
        self.limit = limit
        self.maxDistance = maxDistance
    }
}

public struct CitySearchQueryRequest {
    public let query: String
    
    /// Zero or negative will result in all the results being returend
    public let limit: Int
}

public final class CitiesManager: CitiesService {
    public private(set) var isReady: Bool = false
    
    private let searchAccelerator = SearchAccelerator<[City]>()
    private var cities: [City] = []
    
    public init() {
        loadCities()
    }
    
    private func loadCities() {
        DispatchTools.onBackground { [weak self] in
            let bundle = Bundle(for: CitiesManager.self)
            
            guard let url = bundle.url(forResource: "city.list", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let cities = try? JSONDecoder().decode([City].self, from: data) else {
                return assertionFailure("Failed to load `city.list`")
            }
            
            self?.cities = cities
            self?.isReady = true
        }
    }
    
    public func citiesFor(_ request: CityLocationRequest, completion: @escaping (([City]) -> Void)) {
        guard isReady else {
            return DispatchTools.onMain {
                completion([])
            }
        }
        
        let requestLocation = CLLocation(latitude: request.coordinate.latitude,
                                         longitude: request.coordinate.longitude)
        
        searchAccelerator.perform(searchClosure: { () -> [City] in
            let sortedCitiesWithDistance = self.cities.compactMap { city -> (City, CLLocationDistance)? in
                let distance = city.location.distance(from: requestLocation)
                
                return distance < 1_500 ? (city, distance) : nil
            }.sorted { $0.1 < $1.1 }
            
            if request.limit <= 0 {
                return sortedCitiesWithDistance.map { $0.0 }
            } else {
                return Array(sortedCitiesWithDistance.prefix(request.limit)).map { $0.0 }
            }
        }, completed: { (cities) in
            completion(cities)
        })
    }
    
    public func citiesFor(_ request: CitySearchQueryRequest, completion: @escaping (([City]) -> Void)) {
        guard isReady else {
            return DispatchTools.onMain {
                completion([])
            }
        }
        
        searchAccelerator.perform(searchClosure: { () -> [City] in
            let query = request.query.lowercased()
            
            if query.isEmpty {
                return []
            }
            
            let filteredCities = self.cities.filter { city -> Bool in
                return city.name.lowercased().contains(query)
            }
            
//            let sortedCities = filteredCities.sorted { first, second -> Bool in
//                guard let firstIndex = first.name.lowercased().range(of: query)?.lowerBound,
//                    let secondIndex = second.name.lowercased().range(of: query)?.lowerBound else {
//                        assertionFailure()
//                        return true
//                }
//
//                return firstIndex < secondIndex
//            }
            
            if request.limit <= 0 {
                return filteredCities
            } else {
                return Array(filteredCities.prefix(request.limit))
            }
        }, completed: { (cities) in
            completion(cities)
        })
    }
}
