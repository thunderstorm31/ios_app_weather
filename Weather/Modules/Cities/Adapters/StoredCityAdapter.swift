import UIKit

internal final class StoredCityAdapter: NSObject {
    internal var cities: [City] = []
    
    internal var selectedCity: ((City) -> Void)?
    
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
        let cell = tableView.dequeueReusableCell(for: SearchCityCell.self, indexPath: indexPath)
        
        cell.setCity(city(for: indexPath))
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? SearchCityCell)?.setCity(nil)
    }
}
