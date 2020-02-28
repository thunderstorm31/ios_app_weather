import UIKit

internal final class CityDetailTableAdapter: NSObject {
    private let city: City
    private var sections: [Section] = []
    
    private var todayWeather: TodayWeather?
    private var forecastWeather: ForecastWeather?
    
    private var errorTitle: String?
    private var errorMessage: String?
    
    internal init(city: City) {
        self.city = city
        
        super.init()
        
        reloadContent()
    }
    
    internal func configure(_ tableView: UITableView) {
        tableView.register(cell: CityDetailsCityCell.self)
        tableView.register(cell: CityDetailsLoadingCell.self)
        tableView.register(cell: CityDetailsErrorCell.self)
        
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
    
    internal func setWeather(_ todayWeather: TodayWeather, forecastWeather: ForecastWeather) {
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
        addLoadingSection()
        addErrorSection()
    }
    
    private func addCitySection() {
        let section = Section()
        
        section.addItem(.city(city))
        
        sections.append(section)
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
        case .city(let city):
            return tableView.dequeueReusableCell(for: CityDetailsCityCell.self, indexPath: indexPath)
                .setCity(city)
        case .loading:
            return tableView.dequeueReusableCell(for: CityDetailsLoadingCell.self, indexPath: indexPath)
        case .error(let title, let message):
            return tableView.dequeueReusableCell(for: CityDetailsErrorCell.self, indexPath: indexPath)
                .setErrorTitle(title, message: message)
        }
    }
}
