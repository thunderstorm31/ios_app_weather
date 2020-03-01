import UIKit

internal final class RootOverlayAnimator {
    private let overlay: UIView
    
    private var isActive: Bool = false
    
    internal var traitCollection: UITraitCollection? {
        didSet { traitCollectionDidChange(oldValue) }
    }

    internal init(overlay: UIView) {
        self.overlay = overlay
        
        didHide()
    }
            
    internal func willShow() {
        isActive = true
        
        if traitCollection?.horizontalSizeClass == .compact {
            overlay.isHidden = false
            overlay.alpha = 0
        }
    }
    
    internal func willHide() {}
        
    internal func setPercentageComplete(_ percentage: CGFloat) {
        if traitCollection?.horizontalSizeClass == .compact {
            let workingPercentage = min(1, max(0, percentage))
        
            overlay.alpha = workingPercentage
        }
    }
    
    internal func didShow() {
        if traitCollection?.horizontalSizeClass == .compact {
            overlay.alpha = 1
            overlay.isHidden = false
        }
    }
    
    internal func didHide() {
        isActive = false
        
        overlay.alpha = 0
        overlay.isHidden = true
    }
}

// MARK: - Trait collection
extension RootOverlayAnimator {
    private func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard isActive else {
            return
        }
        
        let displayOverlay = isActive && traitCollection?.horizontalSizeClass == .compact
        
        overlay.isHidden = displayOverlay == false
        overlay.alpha = displayOverlay ? 1 : 0
    }
}
