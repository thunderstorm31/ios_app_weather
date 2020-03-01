import UIKit

extension UIView {
    public func findFirstSuperview<T: UIView>(ofType type: T.Type) -> T? {
        var currentView: UIView? = self
        
        repeat {
            currentView = currentView?.superview
            
            if let t = currentView as? T {
                return t
            }
        } while currentView != nil
        
        return nil
    }
}
