internal final class CityDetailsViewModel {
    internal let city: City
    
    internal let collectionAdapter: CityDetailCollectionAdapter
    
    internal init(city: City) {
        self.collectionAdapter = CityDetailCollectionAdapter(city: city)
        self.city = city
    }
}
