import UIKit

internal final class StoredCityCell: UITableViewCell, NonePannable {
    internal struct ViewModel {
        internal let primaryText: String
        internal let secondaryText: String
        internal let icon: UIImage?
    }
    
    private var viewModel: ViewModel? {
        didSet { updatedViewModel() }
    }
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        imageView?.pin(size: CGSize(width: 44, height: 44))
        imageView?.contentMode = .scaleAspectFit
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel?) -> StoredCityCell {
        self.viewModel = viewModel
        return self
    }
    
    private func updatedViewModel() {
        textLabel?.text = viewModel?.primaryText
        detailTextLabel?.text = viewModel?.secondaryText
        imageView?.image = viewModel?.icon
    }
}
