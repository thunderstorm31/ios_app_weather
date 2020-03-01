import UIKit

internal final class CityDetailsCurrentWeatherCell: CityDetailsTableCell {
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
        iconImageView.pin(height: 80)
        iconImageView.pinTopToSuperview(layoutArea: .layoutMargins)
        iconImageView.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        iconImageView.pinCenterHorizontalToSuperview()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.addParallax(intensity: 15)
        
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowRadius = 4
        iconImageView.layer.shadowOpacity = 0.3
        iconImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}
