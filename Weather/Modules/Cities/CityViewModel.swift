import Foundation

internal struct CityViewModel {
    private let cityStorage: CityStorage
    private let citiesManager = CitiesManager()
    
    internal var searchBarPlaceholder: String { Localization.Cities.searchBarPlaceholder }
    
    internal let searchCityTableAdapter = SearchCityTableAdapter()
    internal let storedCityAdapter = StoredCityAdapter()
    
    internal init(cityStorage: CityStorage) {
        self.cityStorage = cityStorage
        
        storedCityAdapter.cities = cityStorage.cities
    }
    
    internal func performQuery(_ query: String, completion: @escaping (() -> Void)) {
        let query = CitiesManager.SearchQueryRequest(query: query, limit: 50)
        
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
}
