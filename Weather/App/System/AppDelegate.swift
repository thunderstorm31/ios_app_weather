import UIKit

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal func applicationDidFinishLaunching(_ application: UIApplication) {
        registerServices()
    }
    
    private func registerServices() {
        let services = Services.default
        
        try? services.register(CityStorage(), forType: CityStorageService.self)
        try? services.register(CitiesManager(), forType: CitiesService.self)
        try? services.register(WeatherBll(), forType: WeatherService.self)
    }
    
    // MARK: - UISceneSession Lifecycle

    internal func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
