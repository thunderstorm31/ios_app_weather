extension CityDetailTableAdapter {
    internal enum Item {
        case city(City)
        case todayWeatherIcon(String)
        case expectation(String)
        case loading
        case error(String, String)
    }
}
