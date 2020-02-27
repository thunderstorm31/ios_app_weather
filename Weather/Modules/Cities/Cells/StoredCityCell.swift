import UIKit

internal final class StoredCityCell: UITableViewCell {
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setCity(_ city: City?) {
        textLabel?.text = city?.name
        detailTextLabel?.text = city?.countryCode
    }
}
