import UIKit

extension KeyboardManager {
    @available(iOSApplicationExtension, unavailable)
    public func keyboardFrame(in view: UIView) -> CGRect {
        guard let window = view.window else {
            assertionFailure("The view window could not be found")
            return keyboardFrame
        }
        
        return view.convert(keyboardFrame, from: window)
    }
    
    public func keyboardBottomOverlap(in view: UIView) -> CGFloat {
        let keyboardFrame = self.keyboardFrame(in: view)
        
        guard keyboardFrame.minY > 0 else {
            return 0
        }
        
        return max(0, view.bounds.height - keyboardFrame.minY)
    }
}
