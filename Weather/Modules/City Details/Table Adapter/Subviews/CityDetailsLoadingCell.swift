import UIKit

internal final class CityDetailsLoadingCell: CityDetailsTableCell {
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension CityDetailsLoadingCell {
    private func configureViews() {
        [activityIndicatorView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureContentView()
        
        activityIndicatorView.pinCenterToSuperview()
    }
    
    private func configureContentView() {
        contentView.pin(height: 110)
    }
}

// MARK: - CellLifecycle
extension CityDetailsLoadingCell: CellLifecycle {
    internal func cellWillDisplay(at indexPath: IndexPath) {
        activityIndicatorView.startAnimating()
    }
    
    internal func cellDidEndDisplaying(from indexPath: IndexPath) {
        activityIndicatorView.stopAnimating()
    }
}
