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
    
    public func findFirstSuper<T>(ofType type: T.Type) -> T? {
        var currentView: UIView? = self
        
        repeat {
            currentView = currentView?.superview
            
            if let t = currentView as? T {
                return t
            }
        } while currentView != nil
        
        return nil
    }
    
    public func addParallax(intensity: CGFloat) {
        addParallax(intensityX: intensity, intensityY: intensity)
    }
    
    public func addParallax(intensityX: CGFloat, intensityY: CGFloat) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -intensityX
        xMotion.maximumRelativeValue = intensityX
              
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -intensityY
        yMotion.maximumRelativeValue = intensityY
              
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion, yMotion]

        addMotionEffect(motionEffectGroup)
    }
}
