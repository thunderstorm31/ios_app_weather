import UIKit

extension UIColor {
    internal convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .light { return light }
            else { return dark }
        }
    }
}
