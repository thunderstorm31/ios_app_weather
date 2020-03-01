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
    
    private let minMaxTemperatureView = MinMaxTemperatureView()
    
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
        [minMaxTemperatureView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
                
        configureImageView()
        configureMinMaxTemperatureView()
    }
    
    private func configureImageView() {
        imageView?.layer.shadowColor = UIColor.black.cgColor
        imageView?.layer.shadowOpacity = 0.3
        imageView?.layer.shadowRadius = 5
        imageView?.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    private func configureMinMaxTemperatureView() {
        minMaxTemperatureView.pinCenterVerticaltalToSuperview(layoutArea: .layoutMargins)
        minMaxTemperatureView.pinTrailingToSuperview(padding: 15, layoutArea: .layoutMargins)
        
        minMaxTemperatureView.setContentCompressionResistancePriority(.required, for: .horizontal)
        minMaxTemperatureView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}

// MARK: Misc
extension CityDetailsDailyWeatherCell {
    internal func viewModelUpdated() {
        imageView?.image = viewModel?.iconImage
        textLabel?.text = viewModel?.primaryText
        detailTextLabel?.text = viewModel?.secondaryText
        
        let minMaxViewModel = MinMaxTemperatureView.ViewModel(maxTemperature: viewModel?.maxTemperature, minTemperature: viewModel?.minTemperature)
        minMaxTemperatureView.setViewModel(minMaxViewModel)
    }
}
