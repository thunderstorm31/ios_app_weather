extension CityDetailCollectionAdapter {
    internal final class Section {
        internal private(set) var items: [CityDetailCollectionAdapter.Item] = []
    }
}

extension CityDetailCollectionAdapter.Section {
    internal var count: Int { items.count }
    
    internal func addItem(_ item: CityDetailCollectionAdapter.Item) {
        items.append(item)
    }
    
    internal func removeAll() {
        items.removeAll()
    }
    
    internal func item(atIndex index: Int) -> CityDetailCollectionAdapter.Item? {
        items[safe: index]
    }
}
