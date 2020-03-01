import Foundation
import CoreLocation

internal protocol HomeViewModelDelegate: AnyObject {
    func updated(_ cities: [City])
    func centerOn(_ city: City)
}

internal final class HomeViewModel {
    internal typealias AddCityCallback = (AddCityResult) -> Void
    internal enum AddCityResult {
        case added(City), notFound, alreadyAdded(City)
    }
    
    internal weak var delegate: HomeViewModelDelegate?
    
    private let services: Services
    private var cityStorageService: CityStorageService { services.get(CityStorageService.self) }
    private var citiesService: CitiesService { services.get(CitiesService.self) }
        
    internal init(services: Services = .default) {
        self.services = services
        
        cityStorageService.addDelegate(self)
    }
    
    internal func viewDidLoad() {
        delegate?.updated(cityStorageService.cities)
    }
    
    internal func addCity(for coordinate: CLLocationCoordinate2D, completion: @escaping AddCityCallback) {
        let request = CityLocationRequest(coordinate: coordinate, limit: 1)
        
        citiesService.citiesFor(request) { [weak self] cities in
            self?.addFirstCity(from: cities, completion: completion)
        }
    }
    
    private func addFirstCity(from cities: [City], completion: @escaping AddCityCallback) {
        guard let city = cities.first else {
            return completion(.notFound)
        }
        
        guard cityStorageService.cities.contains(city) == false else {
            return completion(.alreadyAdded(city))
        }
        
        cityStorageService.add(city, origin: .map)
        
        completion(.added(city))
    }
}

// MARK: - CityStorageServiceDelegate
extension HomeViewModel: CityStorageServiceDelegate {
    internal func cityStorageService(_ service: CityStorage, updatedStoredCities cities: [City]) {
        delegate?.updated(cities)
    }
    
    internal func cityStorageService(_ service: CityStorage, added city: City, origin: CityStorageAddCityOrigin) {
        switch origin {
        case .search:
            delegate?.centerOn(city)
        case .map:
            break
        }
    }
}
