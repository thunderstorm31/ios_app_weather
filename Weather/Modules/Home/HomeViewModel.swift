import Foundation
import CoreLocation

internal protocol HomeViewModelDelegate: AnyObject {
    func updated(_ cities: [City])
    func centerOn(_ city: City)
    func updateShowUserLocationOnMap(_ show: Bool)
    func updatedWeathers(_ weathers: [City: TodayWeather])
}

internal final class HomeViewModel {
    internal typealias AddCityCallback = (AddCityResult) -> Void
    internal enum AddCityResult {
        case added(City), notFound, alreadyAdded(City)
    }
    
    internal weak var delegate: HomeViewModelDelegate?
    
    internal var showLocationOnMap: Bool { deviceLocationService.isAuthorized }
    
    internal private(set) var weathers: [City: TodayWeather] = [:] {
        didSet { delegate?.updatedWeathers(weathers) }
    }
    
    private let services: Services
    private var cityStorageService: CityStorageService { services.get(CityStorageService.self) }
    private var citiesService: CitiesService { services.get(CitiesService.self) }
    private var deviceLocationService: DeviceLocationService { services.get(DeviceLocationService.self) }
    private var weatherService: WeatherService { services.get(WeatherService.self) }
    private var settingsService: SettingsService { services.get(SettingsService.self) }
        
    internal init(services: Services = .default) {
        self.services = services
        
        cityStorageService.addDelegate(self)
        deviceLocationService.addDelegate(self)
    }
    
    internal func viewDidLoad() {
        delegate?.updated(cityStorageService.cities)
        delegate?.updateShowUserLocationOnMap(deviceLocationService.isAuthorized)
        
        updateWeatherForAllCities()
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
        updateWeather(for: city)
        
        completion(.added(city))
    }
    
    private func updateWeatherForAllCities() {
        cityStorageService.cities.forEach { city in
            updateWeather(for: city)
        }
    }
    
    private func updateWeather(for city: City) {
        let request = TodayWeatherRequest(coordinate: city.coordinates.coordinate, unitSystem: settingsService.unitSystem.openWeatherRequestValue)
        
        weatherService.load(request) { [weak self] (weather, _) in
            if let weather = weather {
                self?.weathers[city] = weather
            }
        }
    }
}

// MARK: - CityStorageServiceDelegate
extension HomeViewModel: CityStorageServiceDelegate {
    internal func cityStorageService(_ service: CityStorage, updatedStoredCities cities: [City]) {
        delegate?.updated(cities)
    }
    
    internal func cityStorageService(_ service: CityStorage, added city: City, origin: CityStorageAddCityOrigin) {
        switch origin {
        case .search, .deviceLocation:
            delegate?.centerOn(city)
        case .map:
            break
        }
    }
}

// MARK: - DeviceLocationServiceDelegate
extension HomeViewModel: DeviceLocationServiceDelegate {
    internal func deviceLocationServiceUpdatedAuthorization(_ service: DeviceLocationService) {
        delegate?.updateShowUserLocationOnMap(service.isAuthorized)
    }
}
