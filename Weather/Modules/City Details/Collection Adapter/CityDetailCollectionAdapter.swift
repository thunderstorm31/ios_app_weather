import UIKit

internal final class CityDetailCollectionAdapter: NSObject {
    private let city: City
    private var sections: [Section] = []
    
    internal init(city: City) {
        self.city = city
        
        super.init()
        
        reloadContent()
    }
    
    internal func configure(_ collectionView: UICollectionView) {
        collectionView.register(cell: CityDetailsCityCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    internal func section(atIndex index: Int) -> Section? {
        sections[safe: index]
    }
    
    internal func item(at indexPath: IndexPath) -> Item? {
        section(atIndex: indexPath.section)?.item(atIndex: indexPath.item)
    }
}

// MARK: - Content
extension CityDetailCollectionAdapter {
    private func reloadContent() {
        sections.removeAll()
        
        addCitySection()
    }
    
    private func addCitySection() {
        let section = Section()
        
        section.addItem(.city(city))
        
        sections.append(section)
    }
}

// MARK: - UICollectionViewDelegate
extension CityDetailCollectionAdapter: UICollectionViewDelegate {}

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
            let cell = collectionView.dequeReusableCell(for: CityDetailsCityCell.self, indexPath: indexPath)
            
            cell.city = city
            
            return cell
        }
    }
}
