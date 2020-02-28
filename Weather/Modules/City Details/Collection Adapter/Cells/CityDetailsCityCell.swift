import UIKit

internal final class CityDetailsCityCell: UICollectionViewCell {
    private let cityNameLabel = UILabel()
    
    internal var city: City? {
        didSet { updatedCity() }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func configureViews() {
        [cityNameLabel]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        configureContentView()
        configureCityNameLabel()
    }
    
    private func configureContentView() {
        contentView.disableTranslateAutoresizingMask()
        contentView.pinEdgesToSuperview()
    }
    
    private func configureCityNameLabel() {
        cityNameLabel.pinWidth(with: contentView, relation: .lessThanOrEqual)
        cityNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        cityNameLabel.pinCenterHorizontalToSuperview()
        cityNameLabel.pinEdgesVerticalToSuperview(padding: 10)
        
        cityNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func updatedCity() {
        cityNameLabel.text = city?.name
    }
}
