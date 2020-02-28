import Foundation

internal protocol CityDetailsViewModelDelegate: AnyObject {
    func cityDetailsViewModel(_ model: CityDetailsViewModel, updated state: CityDetailsViewModel.State)
}

internal final class CityDetailsViewModel {
    internal enum State {
        case loading, content, error
    }
    
    internal let city: City
    internal let collectionAdapter: CityDetailCollectionAdapter
    
    internal private(set) var state: State = .loading {
        didSet {
            delegate?.cityDetailsViewModel(self, updated: state)
        }
    }
    
    internal private(set) var todayWeather: TodayWeather?
    internal private(set) var forecastWeather: ForecastWeather?
    
    internal weak var delegate: CityDetailsViewModelDelegate?
    
    private let services: Services
    private var weatherService: WeatherService { services.get(WeatherService.self) }
    
    internal init(city: City, services: Services = .default) {
        self.collectionAdapter = CityDetailCollectionAdapter(city: city)
        self.city = city
        self.services = services
        
        loadDailyWeather()
    }
    
    private func loadDailyWeather() {
        let todayRequest = TodayWeatherRequest(coordinate: city.coordinates.coordinate)
        let forecastRequest = ForecastWeatherRequest(coordinate: city.coordinates.coordinate)
        
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
        if self.todayWeather != nil && self.forecastWeather != nil {
            self.state = .content
        } else {
            self.state = .error
        }
    }
}
