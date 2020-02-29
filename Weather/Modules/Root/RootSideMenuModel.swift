import UIKit

internal final class RootSideMenuModel {
    internal let viewController: UIViewController
    internal let menuButtonImage: UIImage?
    
    internal init(viewController: UIViewController, menuButtonImage: UIImage?) {
        self.viewController = viewController
        self.menuButtonImage = menuButtonImage
    }
}
