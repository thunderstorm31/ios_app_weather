import UIKit

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal func applicationDidFinishLaunching(_ application: UIApplication) {
        registerServices()
    }
    
    private func registerServices() {
        guard let keys = loadKeys(), let openWeatherAppId = keys["openWeatherAppId"] else {
            fatalError("Could not load required keys")
        }
        
        let services = Services.default
        
        try? services.register(Settings(), forType: SettingsService.self)
        try? services.register(OpenWeatherDAL(appId: openWeatherAppId), forType: OpenWeatherService.self)
        try? services.register(CityStorage(), forType: CityStorageService.self)
        try? services.register(CitiesManager(), forType: CitiesService.self)
        try? services.register(WeatherBll(), forType: WeatherService.self)
    }
    
    // MARK: - UISceneSession Lifecycle

    internal func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func loadKeys() -> [String: String]? {
        var propertyListFormat: PropertyListSerialization.PropertyListFormat = .xml
        
        guard let url = Bundle.main.url(forResource: "keys", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: &propertyListFormat) as? [String: String] else {
                return nil
        }
        
        return result
    }
}
