import UIKit

internal final class RootContainerAnimator {
    internal enum Side {
        case leading, trailing
    }
    
    internal enum State {
        case hidden, panning(CGFloat), visible
    }
    
    private let menuButton: UIView
    private let container: UIView
    private let side: Side
    
    internal private(set) var state: State = .hidden {
        didSet { updatedState?(state) }
    }
    
    internal var updatedState: ((State) -> Void)?
    
    internal var sidePadding: CGFloat = 10
    internal var isVisible: Bool { container.isHidden == false }
    
    internal var currentPanning: CGFloat {
        switch state {
        case .hidden:
            return 0
        case .visible:
            return sidePadding + container.bounds.width
        case .panning(let value):
            return sidePadding + container.bounds.width - abs(value)
        }
    }
    
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
        
        didHide()
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
                
        let translateX = hiddenTranslation * workingPercentage
        
        menuButton.isHidden = workingPercentage <= 0
        menuButton.alpha = workingPercentage
        container.transform = CGAffineTransform(translationX: translateX, y: 0)
        
        if workingPercentage >= 1 {
            state = .hidden
        } else if workingPercentage <= 0 {
            state = .visible
        } else {
            state = .panning(translateX)
        }
    }
    
    internal func didShow() {
        menuButton.isHidden = true
        menuButton.alpha = 0
        
        container.isHidden = false
        container.transform = .identity
        
        state = .visible
    }
    
    internal func didHide() {
        menuButton.alpha = 1
        menuButton.isHidden = false
        
        container.isHidden = true
        container.transform = CGAffineTransform(translationX: hiddenTranslation, y: 0)
        
        state = .hidden
    }
}
