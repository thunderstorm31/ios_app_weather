import UIKit

internal final class CityDetailsCityCell: UITableViewCell {
    private let cityNameLabel = UILabel()
    
    internal private(set) var city: City? {
        didSet { updatedCity() }
    }
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setCity(_ city: City) -> CityDetailsCityCell {
        self.city = city
        
        return self
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func configureViews() {
        [cityNameLabel]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
        configureCityNameLabel()
    }
    
    private func configureCityNameLabel() {
        cityNameLabel.pinWidth(with: contentView, relation: .lessThanOrEqual)
        cityNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        cityNameLabel.pinCenterHorizontalToSuperview()
        cityNameLabel.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        
        cityNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func updatedCity() {
        cityNameLabel.text = city?.name
    }
}
