extension CityDetailTableAdapter {
    internal enum Item {
        case city(CityDetailsCityCell.ViewModel)
        case currentWeather(CityDetailsCurrentWeatherCell.ViewModel)
        case dailyWeather(CityDetailsDailyWeatherCell.ViewModel)
        case hourlyForecast(CityDetailsHourlyForecastCell.ViewModel)
        case dayTitle(CityDetailsDayTitleCell.ViewModel)
        case currentConditions(CityDetailsCurrentConditionsCell.ViewModel)
        case loading
        case error(String, String)
    }
}
