import UIKit

internal final class CurrentCondtionItemView: UIView {
    internal struct ViewModel {
        internal let primaryText: String?
        internal let icon: UIImage?
    }
    
    private let iconView = UIImageView()
    private let primaryLabel = UILabel()
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
        traitCollectionDidChange(nil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel) -> CurrentCondtionItemView {
        self.viewModel = viewModel
        
        return self
    }
    
    private func viewModelUpdated() {
        primaryLabel.text = viewModel?.primaryText
        iconView.image = viewModel?.icon
    }
}

// MARK: Configure Views
extension CurrentCondtionItemView {
    private func configureViews() {
        [primaryLabel, iconView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(horizontal: 10, vertical: 3)
        
        layer.cornerRadius = 16
        backgroundColor = .secondarySystemBackground
        
        configurePrimaryLabel()
        configureIconView()
    }
    
    private func configurePrimaryLabel() {
        primaryLabel.pinCenterVerticaltalToSuperview(layoutArea: .layoutMargins)
        primaryLabel.pin(nextTo: iconView, padding: 10)
        primaryLabel.pinTrailingToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        primaryLabel.setContentHuggingPriority(.required, for: .horizontal)
        primaryLabel.font = .preferredFont(forTextStyle: .caption1)
        primaryLabel.textColor = .secondaryLabel
    }
    
    private func configureIconView() {
        iconView.pinLeadingToSuperview(layoutArea: .layoutMargins)
        iconView.pinCenterVerticaltalToSuperview(layoutArea: .layoutMargins)
        iconView.pin(singleSize: 22)
        iconView.contentMode = .scaleAspectFit
    }
}

// MARK: Trait collection
extension CurrentCondtionItemView {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layer.borderWidth = traitCollection.pixelSize
        layer.borderColor = UIColor.separator.cgColor
    }
}
