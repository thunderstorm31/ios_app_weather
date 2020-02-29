import UIKit

internal final class RootMenuButton: UIButton {
    internal override var isHighlighted: Bool {
        didSet { updatedHighlightedState() }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
        updatedHighlightedState()
        traitCollectionDidChange(nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension RootMenuButton {
    private func configureViews() {
        layer.cornerRadius = 8
    }
}

// MARK: Trait Collection
extension RootMenuButton {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layer.borderWidth = traitCollection.pixelSize
        layer.borderColor = UIColor.separator.cgColor
    }
}

// MARK: Misc
extension RootMenuButton {
    private func updatedHighlightedState() {
        if isHighlighted {
            backgroundColor = .tertiarySystemBackground
        } else {
            backgroundColor = .secondarySystemBackground
        }
    }
}
