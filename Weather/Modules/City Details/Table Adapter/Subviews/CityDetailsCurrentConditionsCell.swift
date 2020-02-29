import UIKit

internal final class CityDetailsCurrentConditionsCell: UITableViewCell {
    internal struct ViewModel {
        internal let items: [CurrentCondtionItemView.ViewModel]
    }
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    private let contentStackView = UIStackView()
    private let rowStackViews: [UIStackView] = [UIStackView(), UIStackView(), UIStackView()]
        
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel) -> CityDetailsCurrentConditionsCell {
        self.viewModel = viewModel
        
        return self
    }
    
    private func viewModelUpdated() {
        rowStackViews.forEach { stackView in
            stackView.arrangedSubviews.forEach {
                $0.constraints.deactivateConstraints()
                $0.constraints.forEach(stackView.removeConstraint)
                
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        }
        
        viewModel?.items.enumerated().forEach { offset, model in
            let rowIndex = offset % 3
            
            let view = CurrentCondtionItemView()
                .setViewModel(model)
            
            view.pin(height: 35)
            
            rowStackViews[rowIndex].addArrangedSubview(view)
        }
    }
}

// MARK: Configure Views
extension CityDetailsCurrentConditionsCell {
    private func configureViews() {
        [contentStackView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        rowStackViews.forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        configureContentStackView()
        configureRowStackViews()
    }
    
    private func configureContentStackView() {
        contentStackView.pinEdgesToSuperview(layoutArea: .layoutMargins)
        
        contentStackView.distribution = .fillEqually
        contentStackView.alignment = .center
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
    }
    
    private func configureRowStackViews() {
        rowStackViews.forEach {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.distribution = .equalSpacing
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
    }
}
