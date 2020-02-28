import UIKit

internal final class CityDetailsLoadingCell: UICollectionViewCell {
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        contentView.disableTranslateAutoresizingMask()
        contentView.pinEdgesToSuperview()
        contentView.pin(height: 100)
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
