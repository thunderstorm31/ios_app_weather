import UIKit

internal final class CityDetailCollectionAdapter: NSObject {
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
    
    internal func configure(_ collectionView: UICollectionView) {
        collectionView.register(cell: CityDetailsCityCell.self)
        collectionView.register(cell: CityDetailsLoadingCell.self)
        collectionView.register(cell: CityDetailsErrorCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
extension CityDetailCollectionAdapter {
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

// MARK: - UICollectionViewDelegate
extension CityDetailCollectionAdapter: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? CellLifecycle)?.cellWillDisplay(at: indexPath)
    }

    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? CellLifecycle)?.cellDidEndDisplaying(from: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension CityDetailCollectionAdapter: UICollectionViewDataSource {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int { sections.count }
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section(atIndex: section)?.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.item(at: indexPath) else {
            fatalError("Could not retrieve item at: \(indexPath)")
        }
        
        switch item {
        case .city(let city):
            return collectionView.dequeReusableCell(for: CityDetailsCityCell.self, indexPath: indexPath)
                .setCity(city)
        case .loading:
            return collectionView.dequeReusableCell(for: CityDetailsLoadingCell.self, indexPath: indexPath)
        case .error(let title, let message):
            return collectionView.dequeReusableCell(for: CityDetailsErrorCell.self, indexPath: indexPath)
                .setErrorTitle(title, message: message)
        }
    }
}
