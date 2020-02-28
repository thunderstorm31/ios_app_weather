extension CityDetailCollectionAdapter {
    internal enum Item {
        case city(City)
        case loading
        case error(String, String)
    }
}
