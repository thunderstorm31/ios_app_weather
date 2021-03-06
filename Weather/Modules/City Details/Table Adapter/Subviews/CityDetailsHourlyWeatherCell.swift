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
        
        traitCollectionDidChange(nil)
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
        configureBackgroundView()
    }
    
    private func configureHourLabel() {
        hourLabel.pinTopToSuperview(layoutArea: .layoutMargins)
        hourLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        hourLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        hourLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        hourLabel.textColor = .secondaryLabel
        hourLabel.addParallax(intensity: 10)
    }

    private func configureTemperatureLabel() {
        temperatureLabel.pinBottomToSuperview(layoutArea: .layoutMargins)
        temperatureLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        temperatureLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .body)
        temperatureLabel.addParallax(intensity: 10)
    }
    
    private func configureIconView() {
        iconView.pinCenterToSuperview(layoutArea: .layoutMargins)
        iconView.pin(singleSize: 28)
        iconView.contentMode = .scaleAspectFit
        iconView.addParallax(intensity: 10)
        
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.3
        iconView.layer.shadowRadius = 5
        iconView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    private func configureBackgroundView() {
        backgroundView = UIView()
        
        backgroundView?.disableTranslateAutoresizingMask()
        backgroundView?.pinEdgesToSuperview()
        backgroundView?.layer.cornerRadius = 16
        backgroundView?.backgroundColor = .secondarySystemBackground
    }
}

// MARK: Trait collection
extension CityDetailsHourlyWeatherCell {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backgroundView?.layer.borderWidth = traitCollection.pixelSize
        backgroundView?.layer.borderColor = UIColor.separator.cgColor
    }
}
