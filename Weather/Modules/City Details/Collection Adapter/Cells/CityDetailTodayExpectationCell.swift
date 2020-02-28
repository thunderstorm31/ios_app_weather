import UIKit

internal final class CityDetailTodayExpectationCell: UITableViewCell {
    private let expectationLabel = UILabel()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setExpectation(_ expectation: String?) -> CityDetailTodayExpectationCell {
        expectationLabel.text = expectation
        
        return self
    }
}

// MARK: Configure Views
extension CityDetailTodayExpectationCell {
    private func configureViews() {
        [expectationLabel]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(horizontal: 15, vertical: 3)
        
        configureExpectattionLabel()
    }
    
    private func configureExpectattionLabel() {
        expectationLabel.pinEdgesVerticalToSuperview(layoutArea: .layoutMargins)
        expectationLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        expectationLabel.pinCenterHorizontalToSuperview()
        
        expectationLabel.numberOfLines = 0
    }
}
