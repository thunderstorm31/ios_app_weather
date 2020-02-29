import UIKit

internal final class CityDetailsHourlyWeatherCell: UICollectionViewCell {
    internal struct ViewModel {
        internal let hourText: String?
        internal let temperatureText: String?
        internal let icon: UIImage?
    }
    
    private let hourLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let iconView = UIImageView()
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel) -> CityDetailsHourlyWeatherCell {
        self.viewModel = viewModel
        
        return self
    }
    
    private func viewModelUpdated() {
        hourLabel.text = viewModel?.hourText
        temperatureLabel.text = viewModel?.temperatureText
        iconView.image = viewModel?.icon
    }
}

// MARK: Configure Views
extension CityDetailsHourlyWeatherCell {
    private func configureViews() {
        [hourLabel, temperatureLabel, iconView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureHourLabel()
        configureTemperatureLabel()
        configureIconView()
    }
    
    private func configureHourLabel() {
        hourLabel.pinTopToSuperview(layoutArea: .layoutMargins)
        hourLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        hourLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        hourLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        hourLabel.textColor = .secondaryLabel
    }

    private func configureTemperatureLabel() {
        temperatureLabel.pinBottomToSuperview(layoutArea: .layoutMargins)
        temperatureLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        temperatureLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func configureIconView() {
        iconView.pinCenterToSuperview(layoutArea: .layoutMargins)
        iconView.pin(singleSize: 28)
    }
}
