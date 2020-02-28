import Foundation

internal protocol CityViewModelDelegate: AnyObject {}

internal final class CityViewModel {
    private let services: Services
    private var cityStorage: CityStorageService { services.get(CityStorageService.self) }
    private var citiesManager: CitiesService { services.get(CitiesService.self) }
    
    internal weak var delegate: CityViewModelDelegate?
    
    internal var searchBarPlaceholder: String { Localization.Cities.searchBarPlaceholder }
    
    internal let searchCityTableAdapter = SearchCityTableAdapter()
    internal let storedCityAdapter = StoredCityAdapter()
    
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
    }
    
    internal func performQuery(_ query: String, completion: @escaping (() -> Void)) {
        let query = CitySearchQueryRequest(query: query, limit: 50)
        
        citiesManager.citiesFor(query) { [searchCityTableAdapter] cities in
            searchCityTableAdapter.cities = cities
            completion()
        }
    }
    
    internal func selectedStoredCity(_ city: City) {
        cityStorage.selectedCity = city
    }
    
    internal func selectedSearchedCity(_ city: City) {
        cityStorage.add(city)
        storedCityAdapter.cities = cityStorage.cities
    }
    
    internal func deleteAll() {
        cityStorage.cities = []
        storedCityAdapter.cities = []
    }
}

extension CityViewModel: CityStorageServiceDelegate {
    internal func cityStorageService(_ service: CityStorage, updatedStoredCities: [City]) {}
}
