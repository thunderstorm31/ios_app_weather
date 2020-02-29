import Foundation

internal struct Localization {}

extension Localization {
    internal struct Alerts {}
    internal struct Buttons {}
    internal struct Cities {}
    internal struct Settings {}
    internal struct WeatherDetails {}
}

extension Localization.Alerts {
    internal static var deleteAllTitle: String {
        NSLocalizedString("deleteAll.title",
                          tableName: "alerts",
                          value: "Delete all cities",
                          comment: "")
    }
    
    internal static var deleteAllMessage: String {
        NSLocalizedString("deleteAll.message",
                          tableName: "alerts",
                          value: "Are you sure?",
                          comment: "")
    }
}

extension Localization.Buttons {
    internal static var cancelTitle: String {
        NSLocalizedString("cancel.title",
                          tableName: "buttons",
                          value: "Cancel",
                          comment: "")
    }
    internal static var closeTitle: String {
        NSLocalizedString("close.title",
                          tableName: "buttons",
                          value: "Close",
                          comment: "")
    }
    
    internal static var deleteAllTitle: String {
        NSLocalizedString("deleteAll.title",
                          tableName: "buttons",
                          value: "Delete all",
                          comment: "")
    }
}

extension Localization.Cities {
    internal static var searchBarPlaceholder: String {
        NSLocalizedString("searchBar.placeholder",
                          tableName: "cities",
                          value: "Search...",
                          comment: "")
    }
}

extension Localization.Settings {
    internal static var navigationTitle: String {
        NSLocalizedString("settings.naviation.title",
                          tableName: "settings",
                          value: "Settings",
                          comment: "")
    }
    
    internal static var helpItemTitle: String {
        NSLocalizedString("help.item.title",
                          tableName: "settings",
                          value: "Help",
                          comment: "")
    }
}

extension Localization.WeatherDetails {
    internal static var today: String {
        NSLocalizedString("today.text",
                          tableName: "weatherDetails",
                          value: "Today",
                          comment: "")
    }
    
    internal static var loadingErrorTitle: String {
        NSLocalizedString("loading.error.title",
                          tableName: "weatherDetails",
                          value: "Failed loading data",
                          comment: "")
    }
    
    internal static var loadingErrorMessage: String {
        NSLocalizedString("loading.error.message",
                          tableName: "weatherDetails",
                          value: "Failed loading weather data, please check your internet connection and try again",
                          comment: "")
    }
}
