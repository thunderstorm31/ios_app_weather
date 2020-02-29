import UIKit

internal final class StoredCityAdapter: NSObject {
    internal var cities: [City] = []
    internal var weathers: [City: TodayWeather] = [:]
    
    internal var selectedCity: ((City) -> Void)?
    internal var deleteItem: ((IndexPath) -> Bool)?
    
    internal func configure(_ tableView: UITableView) {
        tableView.register(cell: StoredCityCell.self)
    }
    
    internal func setActive(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    internal func city(for indexPath: IndexPath) -> City? { cities[safe: indexPath.item] }
}

// MARK: UITableViewDelegate
extension StoredCityAdapter: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if deleteItem == nil {
            return .none
        } else {
            return .delete
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 88 }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let city = self.city(for: indexPath) else {
            return
        }
        
        selectedCity?(city)
    }
}

// MARK: UITableViewDataSource
extension StoredCityAdapter: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cities.count }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: StoredCityCell.self, indexPath: indexPath)
        
        configure(cell: cell, in: tableView, at: indexPath)
        
        return cell
    }
    
    internal func configure(cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = cell as? StoredCityCell,
            let city = self.city(for: indexPath) else {
            return
        }
        
        let icon: UIImage?
        
        if let weatherId = weathers[city]?.weather.first?.id {
            let symbolName = WeatherIdToSymbolHelper.symbolName(for: weatherId, isDayTime: true)
            
            icon = UIImage(systemName: symbolName)
        } else {
            icon = nil
        }
        
        let viewModel = StoredCityCell.ViewModel(primaryText: city.name, secondaryText: city.countryCode, icon: icon)
        
        cell.setViewModel(viewModel)
    }
    
    internal func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? StoredCityCell)?.setViewModel(nil)
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = deleteItem else {
            return
        }
        
        if deleteItem(indexPath) {
            cities.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
}
