import UIKit

internal final class CityDetailsCurrentWeatherCell: UITableViewCell {
    internal struct ViewModel {
        internal let icon: UIImage?
    }
    
    private let iconImageView = UIImageView()
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewModel(_ viewModel: ViewModel?) -> CityDetailsCurrentWeatherCell {
        self.viewModel = viewModel
        
        return self
    }
    
    private func viewModelUpdated() {
        iconImageView.image = viewModel?.icon
    }
}

// MARK: Configure Views
extension CityDetailsCurrentWeatherCell {
    private func configureViews() {
        [iconImageView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)
        
        configureIconImageView()
    }
    
    private func configureIconImageView() {
        iconImageView.pin(singleSize: 80)
        iconImageView.pinTopToSuperview(layoutArea: .layoutMargins)
        iconImageView.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        iconImageView.pinCenterHorizontalToSuperview()
    }
}
