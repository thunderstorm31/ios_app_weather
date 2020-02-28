import UIKit

internal final class CityDetailsWeatherIconCell: UITableViewCell {
    private let iconImageView = UIImageView()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setSymbolName(_ symbolName: String?) -> CityDetailsWeatherIconCell {
        if let symbolName = symbolName {
            iconImageView.image = UIImage(systemName: symbolName)
        } else {
            iconImageView.image = nil
        }
        
        return self
    }
}

// MARK: Configure Views
extension CityDetailsWeatherIconCell {
    private func configureViews() {
        [iconImageView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        
        configureIconImageView()
    }
    
    private func configureIconImageView() {
        iconImageView.pin(singleSize: 80)
        iconImageView.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        iconImageView.pinCenterHorizontalToSuperview()
    }
}
