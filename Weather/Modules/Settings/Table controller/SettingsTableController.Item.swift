import UIKit

extension SettingsTableController {
    internal final class Item {
        internal let cellIdentifier: String
        internal var primaryText: String
        internal var secondaryText: String?
        
        internal var onSelect: (() -> Void)?
        internal var accessoryType: UITableViewCell.AccessoryType?
        
        internal init(primaryText: String,
                      secondaryText: String? = nil,
                      cellIdentifier: String = SettingsTableCell.identifer,
                      accessoryType: UITableViewCell.AccessoryType? = nil) {
            self.primaryText = primaryText
            self.secondaryText = secondaryText
            self.cellIdentifier = cellIdentifier
            self.accessoryType = accessoryType
        }
    }
}
