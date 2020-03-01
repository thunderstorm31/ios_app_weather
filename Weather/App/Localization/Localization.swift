import Foundation

internal struct Localization {}

extension Localization {
    internal struct Alerts {}
    internal struct Buttons {}
    internal struct Cities {}
    internal struct Settings {}
    internal struct UnitSystem {}
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
    
    internal static var noCityFoundTitle: String {
        NSLocalizedString("noCityFound.title",
                          tableName: "home",
                          value: "Could not find any cities near your selection",
                          comment: "")
    }
    
    internal static var noCityFoundMessage: String {
        NSLocalizedString("noCityFound.title",
                          tableName: "home",
                          value: "Please try another location.",
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
    
    internal static var okTitle: String {
        NSLocalizedString("ok.title",
                          tableName: "alerts",
                          value: "Ok",
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
    
    internal static var contactItemTitle: String {
        NSLocalizedString("contact.item.title",
                          tableName: "settings",
                          value: "Contact support",
                          comment: "")
    }
    
    internal static var unitSystemItemTitle: String {
        NSLocalizedString("unitSystem.item.title",
                          tableName: "settings",
                          value: "Unit system",
                          comment: "")
    }
    
    internal static var unitSystemItemMetric: String {
        NSLocalizedString("unitSystem.item.metric",
                          tableName: "settings",
                          value: "Metric",
                          comment: "")
    }
    
    internal static var unitSystemItemImperial: String {
        NSLocalizedString("unitSystem.item.imperial",
                          tableName: "settings",
                          value: "Imperial",
                          comment: "")
    }
}

extension Localization.UnitSystem {
    internal static var kilometersPerHourAbbreviation: String {
        NSLocalizedString("kilometersPerHour.abbreviation",
                          tableName: "unitSystem",
                          value: "km/h",
                          comment: "")
    }
    
    internal static var milesPerHourAbbreviation: String {
        NSLocalizedString("milesPerHour.abbreviation",
                          tableName: "unitSystem",
                          value: "mi/h",
                          comment: "")
    }
    
    internal static var kilometersAbbreviation: String {
        NSLocalizedString("kilometersPerHour.abbreviation",
                          tableName: "unitSystem",
                          value: "km",
                          comment: "")
    }
    
    internal static var milesAbbreviation: String {
        NSLocalizedString("milesPerHour.abbreviation",
                          tableName: "unitSystem",
                          value: "mi",
                          comment: "")
    }
    
    internal static var millimeterAbbreviation: String {
        NSLocalizedString("millimeter.abbreviation",
                          tableName: "unitSystem",
                          value: "mm",
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
