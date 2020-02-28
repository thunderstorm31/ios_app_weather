import UIKit

internal final class SettingsTableCell: UITableViewCell {
    internal static let identifer = "SettingsTableCell"
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension SettingsTableCell {
    private func configureViews() {        
    }
}
