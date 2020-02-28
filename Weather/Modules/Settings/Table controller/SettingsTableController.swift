import UIKit

internal final class SettingsTableController: NSObject {
    private let services: Services
    
    private var sections: [Section] = []
    
    private let helpSection = Section()
    private let helpItem = Item(primaryText: Localization.Settings.helpItemTitle, accessoryType: .disclosureIndicator)
    
    internal init(services: Services) {
        self.services = services
        
        super.init()
        
        configureSections()
    }
    
    internal func configure(_ tableView: UITableView) {
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifer)
        
        tableView.rowHeight = 44
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    internal func section(atIndex index: Int) -> Section? {
        sections[safe: index]
    }
    
    internal func item(at indexPath: IndexPath) -> Item? {
        section(atIndex: indexPath.section)?.item(atIndex: indexPath.item)
    }
}

// MARK: - Configure sections
extension SettingsTableController {
    private func configureSections() {
        sections = [helpSection]
        
        configureHelpSection()
    }
    
    private func configureHelpSection() {
        helpSection.addItem(helpItem)
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = self.item(at: indexPath) else {
            return
        }
        
        item.onSelect?()
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.section(atIndex: section)?.count ?? 0 }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.item(at: indexPath) else {
            assertionFailure("Could not retrieve item for index path: \(indexPath)")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
        
        configure(cell, with: item, in: tableView, at: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, with item: SettingsTableController.Item, in tableView: UITableView, at indexPath: IndexPath) {
        cell.textLabel?.text = item.primaryText
        cell.detailTextLabel?.text = item.secondaryText
        
        if let accessoryType = item.accessoryType {
            cell.accessoryType = accessoryType
        }
    }
}
