import UIKit

internal final class RootViewController: UIViewController {
    internal enum DisplayMode {
        case main, leadingContainer, trailingContainer
    }
    
    private let mainViewController: UIViewController
    private let leadingSideMenuModel: RootSideMenuModel
    private let trailingSideMenuModel: RootSideMenuModel
    
    private let leadingContainerView: RootViewContainer
    private let trailingContainerView: RootViewContainer
    
    private let leadingMenuButton = RootMenuButton()
    private let trailingMenuButton = RootMenuButton()
    
    private let overlayView = UIView()
    
    private var displayMode: DisplayMode = .main
    
    internal init(mainViewController: UIViewController,
                  leadingSideMenuModel: RootSideMenuModel,
                  trailingSideMenuModel: RootSideMenuModel) {
        self.mainViewController = mainViewController
        self.leadingSideMenuModel = leadingSideMenuModel
        self.trailingSideMenuModel = trailingSideMenuModel
        self.leadingContainerView = RootViewContainer(contentViewController: leadingSideMenuModel.viewController)
        self.trailingContainerView = RootViewContainer(contentViewController: trailingSideMenuModel.viewController)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Did Load
extension RootViewController {
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        [mainViewController.view, leadingMenuButton, trailingMenuButton, overlayView, leadingContainerView, trailingContainerView]
            .disableTranslateAutoresizingMask()
            .add(to: view)
        
        configureMainViewController()
        configureLocationsButton()
        configureSettingsButton()
        configureLeadingContainerView()
        configureTrailingContainerView()
        configureOverlayView()
        
        setDisplayMode(.main, animated: false)
    }
    
    private func configureMainViewController() {
        addChild(mainViewController)
        mainViewController.view.pinEdgesToSuperview()
        mainViewController.didMove(toParent: self)
    }
    
    private func configureLocationsButton() {
        leadingMenuButton.pinTopToSuperview(layoutArea: .layoutMargins)
        leadingMenuButton.pinLeadingToSuperview(layoutArea: .layoutMargins)
        leadingMenuButton.pin(singleSize: 44)
        
        leadingMenuButton.setImage(leadingSideMenuModel.menuButtonImage, for: .normal)
        
        leadingMenuButton.addTarget(self, action: #selector(self.tappedLeadingMenuButton(_:)), for: .touchUpInside)
    }
    
    private func configureSettingsButton() {
        trailingMenuButton.pinTopToSuperview(layoutArea: .layoutMargins)
        trailingMenuButton.pinTrailingToSuperview(layoutArea: .layoutMargins)
        trailingMenuButton.pin(singleSize: 44)
        
        trailingMenuButton.setImage(leadingSideMenuModel.menuButtonImage, for: .normal)
        
        trailingMenuButton.addTarget(self, action: #selector(self.tappedTrailingMenuButton(_:)), for: .touchUpInside)
    }
    
    private func configureOverlayView() {
        overlayView.pinEdgesToSuperview()
        overlayView.isHidden = true
        overlayView.alpha = 0
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOverlay(_:)))
        overlayView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureLeadingContainerView() {
        leadingContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: 0).activate()
        leadingContainerView.pinCenterVerticaltalToSuperview(layoutArea: .safeArea)
        leadingContainerView.pinLeadingToSuperview(padding: 10)
        leadingContainerView.isHidden = true
        
        let bounds = UIScreen.main.bounds
        let width = min(450, min(bounds.height, bounds.width) - 60)
        
        leadingContainerView.pin(width: width)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pannedLeadingContainer(_:)))
        
        leadingContainerView.addGestureRecognizer(panRecognizer)
    }
    
    private func configureTrailingContainerView() {
        trailingContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: 0).activate()
        trailingContainerView.pinCenterVerticaltalToSuperview(layoutArea: .safeArea)
        trailingContainerView.pinTrailingToSuperview(padding: 10)
        trailingContainerView.isHidden = true
        
        let bounds = UIScreen.main.bounds
        let width = min(450, min(bounds.height, bounds.width) - 60)
        
        trailingContainerView.pin(width: width)
        trailingContainerView.isHidden = true
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pannedTrailingContainer(_:)))
        
        trailingContainerView.addGestureRecognizer(panRecognizer)
    }
}

// MARK: - Display mode
extension RootViewController {
    private var leadingXTransform: CGFloat { -(leadingContainerView.bounds.width + 50) }
    private var trailingXTransform: CGFloat { trailingContainerView.bounds.width + 50 }
    
    private func setLeadingContainerHiddenTransform() {
        leadingContainerView.transform = CGAffineTransform(translationX: leadingXTransform, y: 0)
    }
    
    private func setTrailingContainerHiddenTransform() {
        trailingContainerView.transform = CGAffineTransform(translationX: trailingXTransform, y: 0)
    }
    
    internal func setDisplayMode(_ displayMode: DisplayMode, animated: Bool, completion: (() -> Void)? = nil) {
        setDisplayMode(displayMode, animated: animated, animationDuration: 0.25, completion: completion)
    }
    
    private func setDisplayMode(_ displayMode: DisplayMode, animated: Bool, animationDuration: TimeInterval, completion: (() -> Void)? = nil) {
        guard self.displayMode != displayMode else {
            return
        }
        
        preparAnimate(from: self.displayMode, to: displayMode)
        
        let animations: () -> Void = {
            self.animate(from: self.displayMode, to: displayMode)
        }
        
        let animationCompletion: (Bool) -> Void = { _ in
            self.completedAnimation(from: self.displayMode, to: displayMode)
            completion?()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: animations, completion: animationCompletion)
        } else {
            animations()
            animationCompletion(true)
        }
    }
    
    private func preparAnimate(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        if displayMode != .main {
            overlayView.isHidden = false
            overlayView.alpha = 0
        }
        
        leadingMenuButton.isHidden = false
        trailingMenuButton.isHidden = false
        
        switch self.displayMode {
        case .leadingContainer:
            leadingSideMenuModel.viewController.willMove(toParent: nil)
        case .trailingContainer:
            trailingSideMenuModel.viewController.willMove(toParent: nil)
        case .main:
            break
        }
        
        switch displayMode {
        case .leadingContainer:
            addChild(leadingSideMenuModel.viewController)
            leadingContainerView.isHidden = false
            setLeadingContainerHiddenTransform()
            
        case .trailingContainer:
            addChild(trailingSideMenuModel.viewController)
            trailingContainerView.isHidden = false
            setTrailingContainerHiddenTransform()
        case .main:
            break
        }
    }
    
    private func animate(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        if displayMode == .main {
            self.overlayView.alpha = 0
        } else {
            self.overlayView.alpha = 1
        }

        self.leadingMenuButton.alpha = displayMode == .leadingContainer ? 0 : 1
        self.trailingMenuButton.alpha = displayMode == .trailingContainer ? 0 : 1
        
        switch displayMode {
        case .main:
            self.setTrailingContainerHiddenTransform()
            self.setLeadingContainerHiddenTransform()
        case .leadingContainer:
            self.leadingContainerView.transform = .identity
            self.setTrailingContainerHiddenTransform()
        case .trailingContainer:
            self.trailingContainerView.transform = .identity
            self.setLeadingContainerHiddenTransform()
        }
    }
    
    private func completedAnimation(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        switch previousDisplayMode {
        case .leadingContainer:
            self.leadingSideMenuModel.viewController.removeFromParent()
            self.leadingSideMenuModel.viewController.didMove(toParent: nil)
        case .trailingContainer:
            self.trailingSideMenuModel.viewController.removeFromParent()
            self.trailingSideMenuModel.viewController.didMove(toParent: nil)
        case .main:
            break
        }
        
        self.leadingMenuButton.isHidden = displayMode == .leadingContainer
        self.trailingMenuButton.isHidden = displayMode == .trailingContainer
        
        self.overlayView.isHidden = displayMode == .main
        
        self.leadingContainerView.isHidden = displayMode != .leadingContainer
        self.trailingContainerView.isHidden = displayMode != .trailingContainer
        
        self.displayMode = displayMode
    }
}

// MARK: - User Interaction
extension RootViewController {
    @objc
    private func tappedLeadingMenuButton(_ sender: RootMenuButton) {
        setDisplayMode(.leadingContainer, animated: true)
    }
    
    @objc
    private func tappedTrailingMenuButton(_ sender: RootMenuButton) {
        setDisplayMode(.trailingContainer, animated: true)
    }
    
    @objc
    private func tappedOverlay(_ sender: UITapGestureRecognizer) {
        setDisplayMode(.main, animated: true)
    }
    
    @objc
    private func pannedLeadingContainer(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            
            leadingContainerView.transform = CGAffineTransform(translationX: min(0, translation.x), y: 0)
        case .ended:
            let translation = sender.translation(in: view)
            let containerWidth = leadingContainerView.bounds.width
            
            if -translation.x > 0.5 * containerWidth || sender.velocity(in: view).x < -1500 {
                let percentage = min(1, max(abs(translation.x) / containerWidth, 0))
                let animationDuration: TimeInterval = 0.25 * TimeInterval(1 - percentage)
                
                setDisplayMode(.main, animated: true, animationDuration: animationDuration)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.leadingContainerView.transform = .identity
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc
    private func pannedTrailingContainer(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            
            trailingContainerView.transform = CGAffineTransform(translationX: max(0, translation.x), y: 0)
        case .ended:
            let translation = sender.translation(in: view)
            let containerWidth = trailingContainerView.bounds.width
                        
            if translation.x > 0.5 * containerWidth || sender.velocity(in: view).x > 1500 {
                let percentage = min(1, max(abs(translation.x) / containerWidth, 0))
                let animationDuration: TimeInterval = 0.25 * TimeInterval(1 - percentage)
                
                setDisplayMode(.main, animated: true, animationDuration: animationDuration)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.trailingContainerView.transform = .identity
                }, completion: nil)
            }
        default:
            break
        }
    }
}
