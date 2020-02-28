import Foundation

internal struct Localization {}

extension Localization {
    internal struct Alerts {}
    internal struct Buttons {}
    internal struct Cities {}
}

extension Localization.Alerts {
    internal static var deleteAllTitle: String {
        NSLocalizedString("deleteAll.title",
                          tableName: "Alerts",
                          value: "Delete all cities",
                          comment: "")
    }
    
    internal static var deleteAllMessage: String {
        NSLocalizedString("deleteAll.message",
                          tableName: "Alerts",
                          value: "Are you sure?",
                          comment: "")
    }
}

extension Localization.Buttons {
    internal static var cancelTitle: String {
        NSLocalizedString("cancel.title",
                          tableName: "Buttons",
                          value: "Cancel",
                          comment: "")
    }
    
    internal static var deleteAllTitle: String {
        NSLocalizedString("deleteAll.title",
                          tableName: "Buttons",
                          value: "Delete all",
                          comment: "")
    }
}

extension Localization.Cities {
    internal static var searchBarPlaceholder: String {
        NSLocalizedString("searchBar.placeholder",
                          tableName: "Cities",
                          value: "Search...",
                          comment: "")
    }
}
