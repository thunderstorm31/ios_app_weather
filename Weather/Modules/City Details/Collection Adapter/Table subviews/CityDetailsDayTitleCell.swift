import UIKit

internal final class CityDetailsDayTitleCell: UITableViewCell {
    internal struct ViewModel {
        internal let primaryText: String?
        internal let maxTemperatureText: String?
        internal let minTemperatureText: String?
        
        internal var minMaxTemperatureViewModel: MinMaxTemperatureView.ViewModel {
            MinMaxTemperatureView.ViewModel(maxTemperature: maxTemperatureText, minTemperature: minTemperatureText)
        }
    }
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    private let minMaxTemperatureView = MinMaxTemperatureView()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewModel(_ viewModel: ViewModel?) -> CityDetailsDayTitleCell {
        self.viewModel = viewModel
        
        return self
    }
    
    private func viewModelUpdated() {
        textLabel?.text = viewModel?.primaryText?.uppercased()
        minMaxTemperatureView.setViewModel(viewModel?.minMaxTemperatureViewModel)
    }
}

// MARK: Configure Views
extension CityDetailsDayTitleCell {
    private func configureViews() {
        [minMaxTemperatureView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        configureContentView()
        configureMinMaxTemperatureView()
    }
    
    private func configureContentView() {
        contentView.pin(height: 32)
    }
    
    private func configureMinMaxTemperatureView() {
        minMaxTemperatureView.pinCenterVerticaltalToSuperview(layoutArea: .layoutMargins)
        minMaxTemperatureView.pinTrailingToSuperview(layoutArea: .layoutMargins)
    }
}
