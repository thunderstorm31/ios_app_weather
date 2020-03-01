import UIKit

internal final class CityDetailsDayTitleCell: CityDetailsTableCell {
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
    
    private let primaryLabel = UILabel()
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
        primaryLabel.text = viewModel?.primaryText?.uppercased()
        minMaxTemperatureView.setViewModel(viewModel?.minMaxTemperatureViewModel)
    }
}

// MARK: Configure Views
extension CityDetailsDayTitleCell {
    private func configureViews() {
        [primaryLabel, minMaxTemperatureView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
                
        configurePrimaryLabel()
        configureMinMaxTemperatureView()
    }
    
    private func configurePrimaryLabel() {
        primaryLabel.font = .preferredFont(forTextStyle: .headline)
        primaryLabel.pinTopToSuperview(padding: 25)
        primaryLabel.pinBottomToSuperview()
        primaryLabel.pinLeadingToSuperview(layoutArea: .layoutMargins)
    }
    
    private func configureMinMaxTemperatureView() {
        minMaxTemperatureView.pinCenterVertical(in: primaryLabel)
        minMaxTemperatureView.pinTrailingToSuperview(layoutArea: .layoutMargins)
    }
}
