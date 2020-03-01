import UIKit

internal final class RootSideMenuModel {
    internal let viewController: UIViewController
    internal let menuButtonImage: UIImage?
    
    internal var onWillDismiss: (() -> Void)?
    internal var onDidDismiss: (() -> Void)?
    
    internal init(viewController: UIViewController, menuButtonImage: UIImage?) {
        self.viewController = viewController
        self.menuButtonImage = menuButtonImage
    }
    
    internal func willDismiss() {
        onWillDismiss?()
    }
    
    internal func didDismiss() {
        onDidDismiss?()
    }
}
