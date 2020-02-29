import UIKit

internal final class CityDetailTableAdapter: NSObject {
    private let city: City
    private let fullDayFormatter = DateFormatter()
    private var sections: [Section] = []
    
    private var todayWeather: TodayWeather?
    private var forecastWeather: HourlyForecasts?
    
    private var errorTitle: String?
    private var errorMessage: String?
    
    internal init(city: City) {
        self.city = city
        
        super.init()
        
        fullDayFormatter.dateFormat = "EEEE"
        
        reloadContent()
    }
    
    internal func configure(_ tableView: UITableView) {
        tableView.register(cell: CityDetailsCityCell.self)
        tableView.register(cell: CityDetailsLoadingCell.self)
        tableView.register(cell: CityDetailsErrorCell.self)
        tableView.register(cell: CityDetailsCurrentWeatherCell.self)
        tableView.register(cell: CityDetailsDailyWeatherCell.self)
        tableView.register(cell: CityDetailsHourlyForecastCell.self)
        tableView.register(cell: CityDetailsDayTitleCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    internal func section(atIndex index: Int) -> Section? {
        sections[safe: index]
    }
    
    internal func item(at indexPath: IndexPath) -> Item? {
        section(atIndex: indexPath.section)?.item(atIndex: indexPath.item)
    }
    
    internal func setWeather(_ todayWeather: TodayWeather, forecastWeather: HourlyForecasts) {
        self.errorTitle = nil
        self.errorMessage = nil
        
        self.todayWeather = todayWeather
        self.forecastWeather = forecastWeather
        
        reloadContent()
    }
    
    internal func setErrorTitle(_ title: String, message: String) {
        self.errorTitle = title
        self.errorMessage = message
        
        self.todayWeather = nil
        self.forecastWeather = nil
        
        reloadContent()
    }
}

// MARK: - Content
extension CityDetailTableAdapter {
    private func reloadContent() {
        sections.removeAll()
        
        addCitySection()
        addTodayWeatherSection()
        addForecastSection()
        
        addLoadingSection()
        addErrorSection()
    }
    
    private func addCitySection() {
        let section = Section()
        
        if let weather = todayWeather?.weather.first {
            let symbolName = WeatherIdToSymbolHelper.symbolName(for: weather.id, isDayTime: true)
            
            let currentWeatherViewModel = CityDetailsCurrentWeatherCell.ViewModel(icon: UIImage(systemName: symbolName))
            section.addItem(.currentWeather(currentWeatherViewModel))
        }
        
        let cityViewModel = CityDetailsCityCell.ViewModel(cityName: city.name,
                                                          currentCondition: todayWeather?.weather.first?.description,
                                                          temperature: temperatureString(forTemperature: todayWeather?.weatherDetails.temperature))
        section.addItem(.city(cityViewModel))
        
        sections.append(section)
    }
    
    private func addTodayWeatherSection() {
        guard let todayWeather = todayWeather, let weather = todayWeather.weather.first else {
            return
        }
        let weatherDetails = todayWeather.weatherDetails
        
        let section = Section()
        let symbolName = WeatherIdToSymbolHelper.symbolName(for: weather.id, isDayTime: true)
        
        let icon = UIImage(systemName: symbolName)
        
        let dailyViewModel = CityDetailsDailyWeatherCell.ViewModel(iconImage: icon,
                                                                   primaryText: Localization.WeatherDetails.today,
                                                                   secondaryText: weather.description,
                                                                   maxTemperature: temperatureString(forTemperature: weatherDetails.temperatureMaximum),
                                                                   minTemperature: temperatureString(forTemperature: weatherDetails.temperatureMinimum))
        
        section.addItem(.dailyWeather(dailyViewModel))
        
        sections.append(section)
    }
    
    private func addForecastSection() {
        guard let dayItems = forecastWeather?.dayItems, dayItems.isNotEmpty else {
            return
        }
                
        let section = Section()
        sections.append(section)
        
        let todayViewModel = CityDetailsHourlyForecastCell.ViewModel(dayItem: dayItems[0])
        section.addItem(.hourlyForecast(todayViewModel))
        
        guard dayItems.count > 1 else {
            return
        }
        
        dayItems[1..<dayItems.count].forEach { dayItem in
            let day = fullDayFormatter.string(from: dayItem.date)
            
            let minimumTemperatureText = temperatureString(forTemperature: dayItem.temperatureMinimum)
            let maximumTemperatureText = temperatureString(forTemperature: dayItem.temperatureMaximum)
            
            let titleViewModel = CityDetailsDayTitleCell.ViewModel(primaryText: day, maxTemperatureText: maximumTemperatureText, minTemperatureText: minimumTemperatureText)
            section.addItem(.dayTitle(titleViewModel))
            
            let hourlyViewModel = CityDetailsHourlyForecastCell.ViewModel(dayItem: dayItem)
            section.addItem(.hourlyForecast(hourlyViewModel))
        }
    }
    
    private func temperatureString(forTemperature temperature: Double?) -> String? {
        if let temperature = temperature {
            return "\(Int(round(temperature)))°"
        } else {
            return nil
        }
    }
    
    private func addLoadingSection() {
        guard todayWeather == nil, forecastWeather == nil, errorMessage == nil else {
            return
        }
        
        let section = Section()
        
        section.addItem(.loading)
        
        sections.append(section)
    }
    
    private func addErrorSection() {
        guard let title = errorTitle, let message = errorMessage else {
            return
        }
        
        let section = Section()
        
        section.addItem(.error(title, message))
        
        sections.append(section)
    }
}

// MARK: - UITableViewDelegate
extension CityDetailTableAdapter: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { false }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? CellLifecycle)?.cellWillDisplay(at: indexPath)
    }

    internal func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? CellLifecycle)?.cellDidEndDisplaying(from: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension CityDetailTableAdapter: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.section(atIndex: section)?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.item(at: indexPath) else {
            fatalError("Could not retrieve item at: \(indexPath)")
        }
        
        switch item {
        case .city(let viewModel):
            return tableView.dequeueReusableCell(for: CityDetailsCityCell.self, indexPath: indexPath)
                .setViewModel(viewModel)
        case .loading:
            return tableView.dequeueReusableCell(for: CityDetailsLoadingCell.self, indexPath: indexPath)
        case .error(let title, let message):
            return tableView.dequeueReusableCell(for: CityDetailsErrorCell.self, indexPath: indexPath)
                .setErrorTitle(title, message: message)
        case .currentWeather(let viewModel):
            return tableView.dequeueReusableCell(for: CityDetailsCurrentWeatherCell.self, indexPath: indexPath)
                .setViewModel(viewModel)
        case .dailyWeather(let viewModel):
            return tableView.dequeueReusableCell(for: CityDetailsDailyWeatherCell.self, indexPath: indexPath)
                .setViewModel(viewModel)
        case .hourlyForecast(let viewModel):
            return tableView.dequeueReusableCell(for: CityDetailsHourlyForecastCell.self, indexPath: indexPath)
                .setViewModel(viewModel)
        case .dayTitle(let viewModel):
            return tableView.dequeueReusableCell(for: CityDetailsDayTitleCell.self, indexPath: indexPath)
                .setViewModel(viewModel)
        }
    }
}
