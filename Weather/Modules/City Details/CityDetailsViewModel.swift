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
        let request = TodayWeatherRequest(coordinate: city.location.coordinate)
        
        weatherService.load(request) { [weak self] weather, error in
            if let weather = weather {
                self?.todayWeather = weather
                self?.state = .content
            } else {
                self?.state = .error
            }
        }
    }
}
