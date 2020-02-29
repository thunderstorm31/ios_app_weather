import UIKit

internal final class CityDetailsErrorCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setErrorTitle(_ title: String?, message: String?) -> CityDetailsErrorCell {
        titleLabel.text = title
        messageLabel.text = message
        
        return self
    }
}

// MARK: Configure Views
extension CityDetailsErrorCell {
    private func configureViews() {
        [titleLabel, messageLabel]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureContentView()
        configureTitleLabel()
        configureMessageLabel()
    }
    
    private func configureContentView() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(horizontal: 20, vertical: 10)
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.pinTopToSuperview(layoutArea: .layoutMargins)
        titleLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        titleLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
    }
    
    private func configureMessageLabel() {
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.pin(below: titleLabel, padding: 5)
        messageLabel.pinBottomToSuperview(layoutArea: .layoutMargins)
        messageLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        messageLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
}
