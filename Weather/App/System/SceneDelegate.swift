import UIKit

internal final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    internal var window: UIWindow?
    
    private var rootViewController: RootViewController? { window?.rootViewController as? RootViewController }
            
    internal override init() {
        
        super.init()
    }

    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
                
        let homeViewModel = HomeViewModel()
        let cityViewModel = CityViewModel()
        let settingsViewModel = SettingsViewModel()
        
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let cityViewController = CityViewController(viewModel: cityViewModel)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        
        let leadingModel = RootSideMenuModel(viewController: UINavigationController(rootViewController: cityViewController), menuButtonImage: UIImage(systemName: "list.bullet"))
        let trailingModel = RootSideMenuModel(viewController: UINavigationController(rootViewController: settingsViewController), menuButtonImage: UIImage(systemName: "gear"))
        
        window.rootViewController = RootViewController(mainViewController: homeViewController,
                                                       leadingSideMenuModel: leadingModel,
                                                       trailingSideMenuModel: trailingModel)
            
        window.makeKeyAndVisible()
        
        self.window = window
        
        cityViewModel.requestClose = { [weak self] in
            self?.rootViewController?.setDisplayMode(.main, animated: true)
        }
        
        cityViewModel.selectedCity = { [weak self] city in
            self?.rootViewController?.setDisplayMode(.main, animated: true) {
                homeViewController.selected(city, updateMapCenter: true)
            }
        }
        
        settingsViewModel.requestClose = { [weak self] in
            self?.rootViewController?.setDisplayMode(.main, animated: true)
        }
        
        leadingModel.onWillDismiss = {
            cityViewController.willDismiss()
        }
        
        leadingModel.onDidDismiss = {
            cityViewController.didDismiss()
        }
    }
}
