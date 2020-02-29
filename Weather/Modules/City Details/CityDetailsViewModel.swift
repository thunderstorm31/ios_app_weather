import Foundation

internal protocol CityDetailsViewModelDelegate: AnyObject {
    func cityDetailsViewModel(_ model: CityDetailsViewModel, updated state: CityDetailsViewModel.State)
}

internal final class CityDetailsViewModel {
    internal enum State {
        case loading, content, error
    }
    
    internal let city: City
    internal let tableAdapter: CityDetailTableAdapter
    
    internal private(set) var state: State = .loading {
        didSet {
            delegate?.cityDetailsViewModel(self, updated: state)
        }
    }
    
    internal private(set) var todayWeather: TodayWeather?
    internal private(set) var forecastWeather: HourlyForecasts?
    
    internal weak var delegate: CityDetailsViewModelDelegate?
    
    private let services: Services
    private var weatherService: WeatherService { services.get(WeatherService.self) }
    private var settingsService: SettingsService { services.get(SettingsService.self) }
    
    internal init(city: City, services: Services = .default) {
        self.tableAdapter = CityDetailTableAdapter(city: city)
        self.city = city
        self.services = services
        
        loadDailyWeather()
    }
    
    private func loadDailyWeather() {
        let todayRequest = TodayWeatherRequest(coordinate: city.coordinates.coordinate, unitSystem: settingsService.unitSystem)
        let forecastRequest = ForecastWeatherRequest(coordinate: city.coordinates.coordinate, unitSystem: settingsService.unitSystem)
        
        DispatchTools.onBackground { [weatherService] in
            let group = DispatchGroup()
            
            group.enter()
            weatherService.load(todayRequest) { [weak self] weather, _ in
                self?.todayWeather = weather
                group.leave()
            }
            
            group.enter()
            weatherService.load(forecastRequest) { [weak self] forecastWeather, _ in
                self?.forecastWeather = forecastWeather
                group.leave()
            }
            
            group.notify(queue: .main) { [weak self] in
                self?.finishedLoadingWeather()
            }
        }
    }
    
    private func finishedLoadingWeather() {
        if let todayWeather = todayWeather, let forecastWeather = forecastWeather {
            tableAdapter.setWeather(todayWeather, forecastWeather: forecastWeather)
            self.state = .content
        } else {
            tableAdapter.setErrorTitle(Localization.WeatherDetails.loadingErrorTitle, message: Localization.WeatherDetails.loadingErrorMessage)
            self.state = .error
        }
    }
}
