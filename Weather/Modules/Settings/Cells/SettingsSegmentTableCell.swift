import UIKit

internal final class SettingsSegmentTableCell: UITableViewCell {
    internal static let identifer = "SettingsSegmentTableCell"
    
    private let segmentedControl = UISegmentedControl()
    
    internal var onSegmentChange: ((Int) -> Void)?
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setItems(_ items: [String], index: Int) {
        segmentedControl.removeAllSegments()
        
        items.reversed().forEach {
            segmentedControl.insertSegment(withTitle: $0, at: 0, animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = index
        segmentedControl.sizeToFit()
    }
}

// MARK: Configure Views
extension SettingsSegmentTableCell {
    private func configureViews() {
        accessoryView = segmentedControl
        
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChanged(_:)), for: .valueChanged)
    }
}

// MARK: User inteeraction
extension SettingsSegmentTableCell {
    @objc
    private func segmentedControlChanged(_ control: UISegmentedControl) {
        onSegmentChange?(control.selectedSegmentIndex)
    }
}
