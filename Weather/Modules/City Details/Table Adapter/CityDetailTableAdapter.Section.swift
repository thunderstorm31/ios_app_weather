extension CityDetailTableAdapter {
    internal final class Section {
        internal private(set) var items: [CityDetailTableAdapter.Item] = []
    }
}

extension CityDetailTableAdapter.Section {
    internal var count: Int { items.count }
    
    internal func addItem(_ item: CityDetailTableAdapter.Item) {
        items.append(item)
    }
    
    internal func removeAll() {
        items.removeAll()
    }
    
    internal func item(atIndex index: Int) -> CityDetailTableAdapter.Item? {
        items[safe: index]
    }
}
