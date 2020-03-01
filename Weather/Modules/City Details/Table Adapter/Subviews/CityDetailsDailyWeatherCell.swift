import UIKit

internal final class CityDetailsDailyWeatherCell: CityDetailsTableCell {
    internal struct ViewModel {
        internal let iconImage: UIImage?
        internal let primaryText: String?
        internal let secondaryText: String?
        internal let maxTemperature: String?
        internal let minTemperature: String?
    }
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    private let temperatureStackview = UIStackView()
    private let maxTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    private let separatorLabel = UILabel()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewModel(_ viewModel: ViewModel) -> CityDetailsDailyWeatherCell {
        self.viewModel = viewModel
        return self
    }
}

// MARK: Configure Views
extension CityDetailsDailyWeatherCell {
    private func configureViews() {
        [temperatureStackview]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        temperatureStackview.addArrangedSubview(maxTemperatureLabel.disableTranslateAutoresizingMask())
        temperatureStackview.addArrangedSubview(separatorLabel.disableTranslateAutoresizingMask())
        temperatureStackview.addArrangedSubview(minTemperatureLabel.disableTranslateAutoresizingMask())
                
        configureTemperatureStackview()
        configureMaxTemperatureLabel()
        configureMinTemperatureLabel()
        configureSeparatorLabel()
    }
    
    private func configureTemperatureStackview() {
        temperatureStackview.spacing = 5
        temperatureStackview.alignment = .center
        temperatureStackview.axis = .horizontal
        
        temperatureStackview.pinCenterVerticaltalToSuperview(layoutArea: .layoutMargins)
        temperatureStackview.pinTrailingToSuperview(padding: 15, layoutArea: .layoutMargins)
        
        temperatureStackview.setContentCompressionResistancePriority(.required, for: .horizontal)
        temperatureStackview.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func configureMaxTemperatureLabel() {
        maxTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        maxTemperatureLabel.textColor = .systemOrange
    }
    
    private func configureMinTemperatureLabel() {
        separatorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        separatorLabel.textColor = .secondaryLabel
        separatorLabel.text = "|"
    }
    
    private func configureSeparatorLabel() {
        minTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        minTemperatureLabel.textColor = .systemBlue
    }
}

// MARK: Misc
extension CityDetailsDailyWeatherCell {
    internal func viewModelUpdated() {
        imageView?.image = viewModel?.iconImage
        textLabel?.text = viewModel?.primaryText
        detailTextLabel?.text = viewModel?.secondaryText
        
        maxTemperatureLabel.text = viewModel?.maxTemperature
        minTemperatureLabel.text = viewModel?.minTemperature
        
        maxTemperatureLabel.isHidden = maxTemperatureLabel.text == nil
        minTemperatureLabel.isHidden = minTemperatureLabel.text == nil
        separatorLabel.isHidden = maxTemperatureLabel.isHidden || minTemperatureLabel.isHidden
    }
}
