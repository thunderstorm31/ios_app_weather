import UIKit

internal final class RootOverlayAnimator {
    private let overlay: UIView

    internal init(overlay: UIView) {
        self.overlay = overlay
    }
            
    internal func willShow() {
        overlay.isHidden = false
        overlay.alpha = 0
    }
    
    internal func willHide() {}
        
    internal func setPercentageComplete(_ percentage: CGFloat) {
        let workingPercentage = min(1, max(0, percentage))
        
        overlay.alpha = workingPercentage
    }
    
    internal func didShow() {
        overlay.alpha = 1
        overlay.isHidden = false
    }
    
    internal func didHide() {
        overlay.alpha = 0
        overlay.isHidden = true
    }
}
