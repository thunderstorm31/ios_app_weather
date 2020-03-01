import UIKit

internal final class RootContainerAnimator {
    internal enum Side {
        case leading, trailing
    }
    
    private let menuButton: UIView
    private let container: UIView
    private let side: Side
    
    internal var sidePadding: CGFloat = 10
    internal var isVisible: Bool { container.isHidden == false }
    
    private var hiddenTranslation: CGFloat {
        switch side {
        case .leading:
            return -(sidePadding + container.bounds.width)
        default:
            return sidePadding + container.bounds.width
        }
    }
    
    internal init(container: UIView, menuButton: UIView, side: Side) {
        self.container = container
        self.menuButton = menuButton
        self.side = side
    }
    
    internal func percentage(forTranslationX translationX: CGFloat) -> CGFloat {
        min(1, max(1 - translationX / hiddenTranslation, 0))
    }
        
    internal func willShow() {
        container.isHidden = false
        container.transform = CGAffineTransform(translationX: hiddenTranslation, y: 0)
    }
    
    internal func willHide() {
        menuButton.isHidden = false
        menuButton.alpha = 0
    }
    
    @discardableResult
    internal func setTranslationX(_ translationX: CGFloat) -> CGFloat {
        let percentage = self.percentage(forTranslationX: translationX)
        
        setPercentageComplete(percentage)
        
        return percentage
    }
    
    internal func setPercentageComplete(_ percentage: CGFloat) {
        let workingPercentage = 1 - min(1, max(0, percentage))
                
        menuButton.alpha = workingPercentage
        container.transform = CGAffineTransform(translationX: hiddenTranslation * workingPercentage, y: 0)
    }
    
    internal func didShow() {
        menuButton.isHidden = true
        menuButton.alpha = 0
        
        container.isHidden = false
        container.transform = .identity
    }
    
    internal func didHide() {
        menuButton.alpha = 1
        menuButton.isHidden = false
        
        container.isHidden = true
        container.transform = CGAffineTransform(translationX: hiddenTranslation, y: 0)
    }
}
