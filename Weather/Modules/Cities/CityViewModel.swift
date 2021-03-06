import Foundation

internal protocol CityViewModelDelegate: AnyObject {
    func reloadContent()
}

internal final class CityViewModel {
    internal var requestClose: (() -> Void)?
    internal var selectedCity: ((City) -> Void)?
    
    private var weathers: [City: TodayWeather] = [:] {
        didSet {
            storedCityAdapter.weathers = weathers
            delegate?.reloadContent()
        }
    }
    
    private let services: Services
    private var cityStorage: CityStorageService { services.get(CityStorageService.self) }
    private var citiesManager: CitiesService { services.get(CitiesService.self) }
    private var weatherService: WeatherService { services.get(WeatherService.self) }
    private var settingsService: SettingsService { services.get(SettingsService.self) }
    
    internal weak var delegate: CityViewModelDelegate?
    
    internal var searchBarPlaceholder: String { Localization.Cities.searchBarPlaceholder }
    
    internal let searchCityTableAdapter = SearchCityTableAdapter()
    internal let storedCityAdapter = StoredCityTableAdapter()
    
    internal init(services: Services = .default) {
        self.services = services
        
        configureStoredCityAdapter()
        
        cityStorage.addDelegate(self)
    }
    
    private func configureStoredCityAdapter() {
        storedCityAdapter.cities = cityStorage.cities
        storedCityAdapter.deleteItem = { [cityStorage] indexPath in
            cityStorage.remove(cityAtIndex: indexPath.item)
        }
        
        storedCityAdapter.movedItem = { [cityStorage] from, to in
            var  cities = cityStorage.cities
            let city = cities.remove(at: from.item)
            cities.insert(city, at: to.item)
            
            cityStorage.cities = cities
        }
    }
    
    internal func performQuery(_ query: String, completion: @escaping (() -> Void)) {
        let query = CitySearchQueryRequest(query: query, limit: 50)
        
        citiesManager.citiesFor(query) { [weak self] cities in
            self?.searchCityTableAdapter.cities = cities
            self?.delegate?.reloadContent()
        }
    }
    
    internal func viewDidLoad() {
        updateWeathers()
    }
    
    internal func selectedStoredCity(_ city: City) {
        selectedCity?(city)
    }
    
    internal func selectedSearchedCity(_ city: City) {
        cityStorage.add(city, origin: .search)
    }
    
    internal func deleteAll() {
        cityStorage.cities = []
        storedCityAdapter.cities = []
    }
    
    private func updateWeathers() {
        cityStorage.cities.forEach {  city in
            let request = TodayWeatherRequest(coordinate: city.coordinates.coordinate, unitSystem: settingsService.unitSystem.openWeatherRequestValue)
            weatherService.load(request) { [weak self] weather, _ in
                if let weather = weather {
                    self?.weathers[city] = weather
                }
            }
        }
    }
}

extension CityViewModel: CityStorageServiceDelegate {
    internal func cityStorageService(_ service: CityStorage, added: City, origin: CityStorageAddCityOrigin) {
        storedCityAdapter.cities = service.cities
        
        delegate?.reloadContent()
        
        updateWeathers()
    }
}
