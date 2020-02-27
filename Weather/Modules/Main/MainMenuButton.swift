import UIKit

internal final class MainMenuButton: UIButton {
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
extension MainMenuButton {
    private func configureViews() {
        layer.cornerRadius = 8
    }
}

// MARK: Trait Collection
extension MainMenuButton {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layer.borderWidth = traitCollection.pixelSize
        layer.borderColor = UIColor.separator.cgColor
    }
}

// MARK: Misc
extension MainMenuButton {
    private func updatedHighlightedState() {
        backgroundColor = UIColor.white.withAlphaComponent(isHighlighted ? 0.3 : 0.5)
    }
}
