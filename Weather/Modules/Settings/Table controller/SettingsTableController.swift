import UIKit

internal final class SettingsTableController: NSObject {
    private let services: Services
    private var settingsService: SettingsService { services.get(SettingsService.self) }
    
    private var sections: [Section] = []
    
    private let unitSettingsSection = Section()
    private let unitSystemItem = Item(primaryText: Localization.Settings.unitSystemItemTitle, cellIdentifier: SettingsSegmentTableCell.identifer)
    
    private let helpSection = Section()
    private let helpItem = Item(primaryText: Localization.Settings.helpItemTitle, accessoryType: .disclosureIndicator)
    
    internal init(services: Services) {
        self.services = services
        
        super.init()
        
        configureSections()
    }
    
    internal func configure(_ tableView: UITableView) {
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifer)
        tableView.register(SettingsSegmentTableCell.self, forCellReuseIdentifier: SettingsSegmentTableCell.identifer)
        
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
        sections = [unitSettingsSection, helpSection]
        
        configureUnitSettingsSection()
        configureHelpSection()
    }
    
    private func configureUnitSettingsSection() {
        unitSettingsSection.addItem(unitSystemItem)
        
        unitSystemItem.segmentItems = [
            Localization.Settings.unitSystemItemMetric,
            Localization.Settings.unitSystemItemImperial
        ]
        
        unitSystemItem.segmentSelectedIndex = settingsService.unitSystem == .metric ? 0 : 1
        unitSystemItem.onSegmentChange = { [weak self] index in
            self?.unitSystemItem.segmentSelectedIndex = index
            self?.settingsService.unitSystem = index == 0 ? .metric : .imperial
        }
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
    
    internal func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        item(at: indexPath)?.isHighlightable ?? false
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
        
        if let segmentCell = cell as? SettingsSegmentTableCell {
            segmentCell.onSegmentChange = item.onSegmentChange
            segmentCell.setItems(item.segmentItems, index: item.segmentSelectedIndex ?? 0)
        }
    }
}
