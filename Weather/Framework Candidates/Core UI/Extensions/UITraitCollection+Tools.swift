import UIKit

extension UITraitCollection {
    // MARK: - Device
    public var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }
    
    public var isPad: Bool {
        return userInterfaceIdiom == .pad
    }
    
    #if os(iOS)
    public func value<T>(phone: @autoclosure () -> T, pad: @autoclosure () -> T) -> T {
        switch userInterfaceIdiom {
        case .pad:
            return pad()
        case .phone:
            return phone()
        default:
            assertionFailure("Should not occur")
            return phone()
        }
    }
    #endif
    
    public static var isTV: Bool {
        #if os(tvOS)
            return true
        #else
            return false
        #endif
    }
    
    // MARK: - Display
    
    public var safeDisplayScale: CGFloat {
        if displayScale <= 0 {
            return 1
        } else {
            return displayScale
        }
    }
    
    public var pixelSize: CGFloat {
        return 1 / safeDisplayScale
    }
    
    // MARK: - Size class
    
    public func value<T>(compact: @autoclosure () -> T, regular: @autoclosure () -> T) -> T {
        switch horizontalSizeClass {
        case .regular:
            return regular()
        case .compact:
            return compact()
        case .unspecified:
            assertionFailure("Invalid horizontalSizeClass")
            return compact()
        @unknown default:
            assertionFailure("Invalid horizontalSizeClass")
            return compact()
        }
    }
    
    // MARK: - Appearance
    
    public func value<T>(light: @autoclosure () -> T, dark: @autoclosure () -> T) -> T {
        guard #available(iOS 13.0, *) else {
            return light()
        }
        
        switch userInterfaceStyle {
        case .light:
            return light()
        case .dark:
            return dark()
        case .unspecified:
            assertionFailure("Invalid userInterfaceStyle")
            return light()
        @unknown default:
            assertionFailure("Invalid userInterfaceStyle")
            return light()
        }
    }
}
