extension SettingsTableController {
    internal final class Section {
        internal private(set) var items: [Item] = []
    }
}

extension SettingsTableController.Section {
    internal var count: Int { items.count }
    
    internal func addItem(_ item: SettingsTableController.Item) {
        items.append(item)
    }
    
    internal func removeAll() {
        items.removeAll()
    }
    
    internal func item(atIndex index: Int) -> SettingsTableController.Item? {
        items[safe: index]
    }
}
