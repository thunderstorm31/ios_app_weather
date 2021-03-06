import UIKit
import CoreLocation

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
    
    private lazy var locationAccessView = RequestLocationAccessView()
    
    private let overlayView = UIView()
    
    private var displayMode: DisplayMode = .main
    private var addCityForCurrentLocation = false
    
    private let services: Services
    private var deviceLocationService: DeviceLocationService { services.get(DeviceLocationService.self) }
    private var popupSettings: PopupSettingsService { services.get(PopupSettingsService.self) }
    private var cityStorageService: CityStorageService { services.get(CityStorageService.self) }
    private var citiesService: CitiesService { services.get(CitiesService.self) }
    
    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        traitCollection.value(phone: UIInterfaceOrientationMask.portrait, pad: .all)
    }
    
    internal init(mainViewController: UIViewController,
                  leadingSideMenuModel: RootSideMenuModel,
                  trailingSideMenuModel: RootSideMenuModel,
                  services: Services = .default) {
        self.services = services
        
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
        configurelocationAccessView()
        
        setDisplayMode(.main, animated: false)
        
        traitCollectionDidChange(nil)
        
        deviceLocationService.addDelegate(self)
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
        
        trailingMenuButton.setImage(trailingSideMenuModel.menuButtonImage, for: .normal)
        
        trailingMenuButton.addTarget(self, action: #selector(self.tappedTrailingMenuButton(_:)), for: .touchUpInside)
    }
    
    private func configureOverlayView() {
        overlayView.pinEdgesToSuperview()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOverlay(_:)))
        overlayView.addGestureRecognizer(tapRecognizer)
    }
    
    private var containerWidth: CGFloat {
        return min(320, max(view.bounds.width - 60, 100))
    }
    
    private func configureLeadingContainerView() {
        configureContainer(leadingContainerView, animator: leadingContainerAnimator, panTarget: #selector(self.pannedLeadingContainer(_:)))
        
        leadingContainerView.pinLeadingToSuperview(padding: leadingContainerAnimator.sidePadding)
    }

    private func configureTrailingContainerView() {
        configureContainer(trailingContainerView, animator: trailingContainerAnimator, panTarget: #selector(self.pannedTrailingContainer(_:)))
        
        trailingContainerView.pinTrailingToSuperview(padding: trailingContainerAnimator.sidePadding)
    }
    
    private func configureContainer(_ container: RootViewContainer, animator: RootContainerAnimator, panTarget: Selector) {
        container.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        container.pin(width: containerWidth)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: panTarget)
        
        panRecognizer.delegate = self
        container.addGestureRecognizer(panRecognizer)
        
        animator.updatedState = { [weak self] _ in
            self?.updateAdditionalSafeAreaInsets()
        }

        addChild(container.contentViewController)
        container.contentViewController.didMove(toParent: self)
    }
    
    private func configurelocationAccessView() {
        guard deviceLocationService.canRequestLocationAccess, popupSettings.didDismissAddCurrentLocationPopup == false else {
            return
        }
        
        mainViewController.view.addSubview(locationAccessView.disableTranslateAutoresizingMask())
        
        locationAccessView.pinCenterHorizontalToSuperview(layoutArea: .safeArea)
        locationAccessView.pin(width: 414, relation: .lessThanOrEqual)
        locationAccessView.pinEdgesHorizontalToSuperview(layoutArea: .safeArea, relation: .greaterThanOrEqual)
        locationAccessView.pinBottomToSuperview(layoutArea: .safeArea, relation: .greaterThanOrEqual)
        locationAccessView.pinBottomToSuperview(padding: 20, relation: .greaterThanOrEqual)
        
        locationAccessView.delegate = self
    }
}

// MARK: - Layout
extension RootViewController {
    internal override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateLayoutMargins()
        updateAdditionalSafeAreaInsets()
    }
    
    internal override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        updateLayoutMargins()
    }
    
    private func updateLayoutMargins() {
        let minimumMargin: CGFloat = 10
        var layoutMargins = view.directionalLayoutMargins
        
        layoutMargins.top = view.safeAreaInsets.top < minimumMargin ? minimumMargin : 0
        layoutMargins.bottom = view.safeAreaInsets.bottom < minimumMargin ? minimumMargin : 0
        
        view.directionalLayoutMargins = layoutMargins
    }
    
    private func updateAdditionalSafeAreaInsets() {
        guard traitCollection.horizontalSizeClass == .regular else {
            mainViewController.additionalSafeAreaInsets = .zero
            
            return
        }
        
        switch leadingContainerAnimator.state {
        case .hidden, .visible:
            mainViewController.additionalSafeAreaInsets.left = leadingContainerAnimator.currentPanning
        case .panning:
            break
        }
        
        switch trailingContainerAnimator.state {
        case .hidden, .visible:
            mainViewController.additionalSafeAreaInsets.right = trailingContainerAnimator.currentPanning
        case .panning:
            break
        }
    }
}

// MARK: - Trait collection
extension RootViewController {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        overlayAnimator.traitCollection = traitCollection
        updateAdditionalSafeAreaInsets()
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
        
        prepareAnimate(from: self.displayMode, to: displayMode)
        
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
    
    private func prepareAnimate(from previousDisplayMode: DisplayMode, to displayMode: DisplayMode) {
        switch previousDisplayMode {
        case .leadingContainer:
            leadingSideMenuModel.viewController.willMove(toParent: nil)
            leadingSideMenuModel.willDismiss()
        case .trailingContainer:
            trailingSideMenuModel.viewController.willMove(toParent: nil)
            trailingSideMenuModel.willDismiss()
        case .main:
            overlayAnimator.willShow()
        }
        
        switch displayMode {
        case .leadingContainer:
            leadingContainerAnimator.willShow()
        case .trailingContainer:
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
            leadingSideMenuModel.didDismiss()
        case .trailingContainer:
            trailingContainerAnimator.didHide()
            trailingSideMenuModel.didDismiss()
        case .main:
            overlayAnimator.didShow()
        }
        
        switch displayMode {
        case .leadingContainer:
            leadingContainerAnimator.didShow()
        case .trailingContainer:
            trailingContainerAnimator.didShow()
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

// MARK: - RequestLocationAccessViewDelegate
extension RootViewController: RequestLocationAccessViewDelegate {
    internal func dismiss(addLocation: Bool) {
        let translateY = locationAccessView.bounds.height + view.safeAreaInsets.bottom
        
        popupSettings.didDismissAddCurrentLocationPopup = true
        
        UIView.animate(withDuration: 0.25, animations: {
            self.locationAccessView.transform = CGAffineTransform(translationX: 0, y: translateY)
        }, completion: { _ in
            self.locationAccessView.removeFromSuperview()
        })
        
        if addLocation {
            addCityForCurrentLocation = true
            deviceLocationService.requestLocationAccess()
        }
    }
}

// MARK: - DeviceLocationServiceDelegate
extension RootViewController: DeviceLocationServiceDelegate {
    internal func deviceLocationServiceUpdatedAuthorization(_ service: DeviceLocationService) {
        guard service.isAuthorized, addCityForCurrentLocation else {
            return
        }
        
        service.startUpdatingLocation()
    }
    
    internal func deviceLocationService(_ service: DeviceLocationService, received locations: [CLLocation]) {
        guard addCityForCurrentLocation, locations.isNotEmpty else {
            return
        }
        
        service.stopUpdatingLocation()
        
        let request = CityLocationRequest(coordinate: locations[0].coordinate, limit: 1, maxDistance: 15_000)
        
        citiesService.citiesFor(request) { [weak self] cities in
            if let city = cities.first {
                self?.addCityForCurrentLocation = false
                
                self?.cityStorageService.add(city, origin: .deviceLocation)
            } else {
                service.startUpdatingLocation()
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension RootViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let view = gestureRecognizer.view else {
            return true
        }
        
        guard let touchedView = view.hitTest(gestureRecognizer.location(in: view), with: nil),
            touchedView.findFirstSuper(ofType: NonePannable.self) != nil else {
                return true
        }
        
        return false
    }
}
