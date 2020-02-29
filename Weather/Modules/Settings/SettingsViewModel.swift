internal final class SettingsViewModel {
    internal let tableController: SettingsTableController
    
    internal var requestClose: (() -> Void)?
    
    internal init(services: Services = .default) {
        self.tableController = SettingsTableController(services: services)
    }
}
