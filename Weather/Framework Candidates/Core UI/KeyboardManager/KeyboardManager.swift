import UIKit

public protocol KeyboardManagerDelegate: AnyObject {
    func keyboardManager(_ manager: KeyboardManager, info: KeyboardManager.Info)
}

public final class KeyboardManager {
    public static let shared = KeyboardManager()
    
    private let delegates = WeakHashTable<KeyboardManagerDelegate>()
    public var keyboardFrame: CGRect { return keyboardInfo.endFrame }
    public private(set) var isKeyboardVisible = false
    public private(set) var keyboardInfo: Info = Info()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(with:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(with:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Delegates related
extension KeyboardManager {
    public func add(delegate: KeyboardManagerDelegate) {
        delegates.add(delegate)
    }
    
    public func remove(delegate: KeyboardManagerDelegate) {
        delegates.remove(delegate)
    }
}

// MARK: Notifications
extension KeyboardManager {
    @objc private func keyboardWillShow(with notification: Notification) {
        keyboardAction(with: .willShow, notification: notification)
    }
    
    @objc private func keyboardDidShow(with notification: Notification) {
        keyboardAction(with: .didShow, notification: notification)
    }
    
    @objc private func keyboardWillHide(with notification: Notification) {
        keyboardAction(with: .willHide, notification: notification)
    }
    
    @objc private func keyboardDidHide(with notification: Notification) {
        keyboardAction(with: .didHide, notification: notification)
    }
    
    private func keyboardAction(with action: KeyBoardDisplayAction, notification: Notification) {
        isKeyboardVisible = action == .willShow || action == .didShow
        
        keyboardInfo = Info(notification: notification, displayAction: action)
        
        delegates.forEach {
            $0.keyboardManager(self, info: keyboardInfo)
        }
    }
}

extension KeyboardManager {
    public enum KeyBoardDisplayAction {
        case willShow, didShow, willHide, didHide
    }
}

extension KeyboardManager {
    public struct Info {
        public let notification: Notification
        public let displayAction: KeyBoardDisplayAction
        
        fileprivate init() {
            var userInfo: [String: Any] = [:]
            
            userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] = UInt(0)
            userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] = TimeInterval(0)
            userInfo[UIResponder.keyboardFrameBeginUserInfoKey] = NSValue(cgRect: .zero)
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] = NSValue(cgRect: .zero)
            
            if #available(iOS 9.0, *) {
                userInfo[UIResponder.keyboardIsLocalUserInfoKey] = false
            }
            
            notification = Notification(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: userInfo)
            displayAction = .didHide
        }
        
        fileprivate init(notification: Notification, displayAction: KeyBoardDisplayAction) {
            self.notification = notification
            self.displayAction = displayAction
        }
    }
}

extension KeyboardManager.Info {
    public var animationOptions: UIView.AnimationOptions {
        guard let curveInt = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            assertionFailure()
            return .curveEaseOut
        }
        
        return UIView.AnimationOptions(rawValue: curveInt << 16)
    }
    
    public var animationDuration: TimeInterval {
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            assertionFailure()
            return 0.25
        }
        
        return timeInterval
    }
    
    public var beginFrame: CGRect {
        guard let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            assertionFailure()
            return .zero
        }
        
        return beginFrame.cgRectValue
    }
    
    public var endFrame: CGRect {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            assertionFailure()
            return .zero
        }
        
        return endFrame.cgRectValue
    }
    
    public var isLocalKeyboard: Bool {
        if #available(iOS 9.0, *) {
            guard let isLocal = notification.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool else {
                assertionFailure()
                return true
            }
            
            return isLocal
        } else {
            return true
        }
    }
    
    public func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        guard displayAction == .willHide || displayAction == .willShow else {
            return
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: animations, completion: completion)
    }
}
