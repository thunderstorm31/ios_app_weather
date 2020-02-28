internal final class SettingsViewModel {
    internal let tableController: SettingsTableController
    
    internal init(services: Services = .default) {
        self.tableController = SettingsTableController(services: services)
    }
}
