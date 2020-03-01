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
    
    private let leadingContainerAnimator: RootContainerAnimator
    private let trailingContainerAnimator: RootContainerAnimator
    private let overlayAnimator: RootOverlayAnimator
    
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
        
        self.leadingContainerAnimator = RootContainerAnimator(container: self.leadingContainerView, menuButton: self.leadingMenuButton, side: .leading)
        self.trailingContainerAnimator = RootContainerAnimator(container: self.trailingContainerView, menuButton: self.trailingMenuButton, side: .trailing)
        self.overlayAnimator = RootOverlayAnimator(overlay: self.overlayView)
        
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
        
        leadingContainerAnimator.didHide()
        trailingContainerAnimator.didHide()
        overlayAnimator.didHide()
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
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOverlay(_:)))
        overlayView.addGestureRecognizer(tapRecognizer)
    }
    
    private var containerWidth: CGFloat {
        let bounds = UIScreen.main.bounds
        return min(450, min(bounds.height, bounds.width) - 60)
    }
    
    private func configureLeadingContainerView() {
        leadingContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: 0).activate()
        leadingContainerView.pinCenterVerticaltalToSuperview(layoutArea: .safeArea)
        leadingContainerView.pinLeadingToSuperview(padding: 10)
                
        leadingContainerView.pin(width: containerWidth)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pannedLeadingContainer(_:)))
        
        leadingContainerView.addGestureRecognizer(panRecognizer)
    }
    
    private func configureTrailingContainerView() {
        trailingContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1, constant: 0).activate()
        trailingContainerView.pinCenterVerticaltalToSuperview(layoutArea: .safeArea)
        trailingContainerView.pinTrailingToSuperview(padding: 10)
        
        trailingContainerView.pin(width: containerWidth)
        trailingContainerView.isHidden = true
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pannedTrailingContainer(_:)))
        
        trailingContainerView.addGestureRecognizer(panRecognizer)
    }
}

// MARK: - Display mode
extension RootViewController {
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
        switch previousDisplayMode {
        case .leadingContainer:
            leadingSideMenuModel.viewController.willMove(toParent: nil)
        case .trailingContainer:
            trailingSideMenuModel.viewController.willMove(toParent: nil)
        case .main:
            overlayAnimator.willShow()
        }
        
        switch displayMode {
        case .leadingContainer:
            addChild(leadingSideMenuModel.viewController)

            leadingContainerAnimator.willShow()
        case .trailingContainer:
            addChild(trailingSideMenuModel.viewController)
            
            trailingContainerAnimator.willShow()
        case .main:
            overlayAnimator.willHide()
        }
    }
    
    private func animate(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        overlayAnimator.setPercentageComplete(displayMode == .main ? 0 : 1)
        
        leadingContainerAnimator.setPercentageComplete(displayMode == .leadingContainer ? 1 : 0)
        trailingContainerAnimator.setPercentageComplete(displayMode == .trailingContainer ? 1 : 0)
    }
    
    private func completedAnimation(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        switch previousDisplayMode {
        case .leadingContainer:
            leadingContainerAnimator.didHide()
            leadingSideMenuModel.viewController.removeFromParent()
            leadingSideMenuModel.viewController.didMove(toParent: nil)
        case .trailingContainer:
            trailingContainerAnimator.didHide()
            trailingSideMenuModel.viewController.removeFromParent()
            trailingSideMenuModel.viewController.didMove(toParent: nil)
        case .main:
            overlayAnimator.didShow()
        }
        
        switch displayMode {
        case .leadingContainer:
            leadingContainerAnimator.didShow()
            leadingSideMenuModel.viewController.didMove(toParent: self)
        case .trailingContainer:
            trailingContainerAnimator.didShow()
            trailingSideMenuModel.viewController.didMove(toParent: self)
        case .main:
            overlayAnimator.didHide()
        }

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
        panned(with: sender, animater: leadingContainerAnimator, overlayAnimator: overlayAnimator)
    }
    
    @objc
    private func pannedTrailingContainer(_ sender: UIPanGestureRecognizer) {
        panned(with: sender, animater: trailingContainerAnimator, overlayAnimator: overlayAnimator)
    }
    
    private func panned(with recognizer: UIPanGestureRecognizer, animater: RootContainerAnimator, overlayAnimator: RootOverlayAnimator) {
        switch recognizer.state {
        case .changed:
            let percentage = animater.setTranslationX(recognizer.translation(in: view).x)
            overlayAnimator.setPercentageComplete(percentage)
        case .ended:
            let percentage = animater.percentage(forTranslationX: recognizer.translation(in: view).x)
            
            if percentage > 0.5 {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    animater.setPercentageComplete(1)
                    overlayAnimator.setPercentageComplete(1)
                }, completion: { _ in
                    animater.didShow()
                    overlayAnimator.didShow()
                })
            } else {
                let animationDuration: TimeInterval = 0.25 * TimeInterval(1 - percentage)
                
                setDisplayMode(.main, animated: true, animationDuration: animationDuration)
            }
        default:
            break
        }
    }
}
