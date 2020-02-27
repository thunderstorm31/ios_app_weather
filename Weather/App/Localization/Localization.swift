import Foundation

internal struct Localization {}

extension Localization { internal struct Cities {} }

extension Localization.Cities {
    internal static var searchBarPlaceholder: String {
        NSLocalizedString("searchBar.placeholder",
                          tableName: "Cities",
                          value: "Search...",
                          comment: "")
    }
}
