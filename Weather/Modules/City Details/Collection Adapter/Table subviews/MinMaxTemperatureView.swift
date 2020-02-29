import UIKit

internal final class MinMaxTemperatureView: UIView {
    internal struct ViewModel {
        internal let maxTemperature: String?
        internal let minTemperature: String?
    }
    
    private let temperatureStackview = UIStackView()
    private let maxTemperatureLabel = UILabel()
    private let minTemperatureLabel = UILabel()
    private let separatorLabel = UILabel()
    
    private var viewModel: ViewModel? {
        didSet { viewModelUpdated() }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel?) -> MinMaxTemperatureView {
        self.viewModel = viewModel
        return self
    }
}

// MARK: Configure Views
extension MinMaxTemperatureView {
    private func configureViews() {
        [temperatureStackview]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        temperatureStackview.addArrangedSubview(maxTemperatureLabel.disableTranslateAutoresizingMask())
        temperatureStackview.addArrangedSubview(separatorLabel.disableTranslateAutoresizingMask())
        temperatureStackview.addArrangedSubview(minTemperatureLabel.disableTranslateAutoresizingMask())
                
        configureTemperatureStackview()
        configureMaxTemperatureLabel()
        configureMinTemperatureLabel()
        configureSeparatorLabel()
    }
    
    private func configureTemperatureStackview() {
        temperatureStackview.spacing = 5
        temperatureStackview.alignment = .center
        temperatureStackview.axis = .horizontal
        
        temperatureStackview.pinEdgesToSuperview()
        
        temperatureStackview.setContentCompressionResistancePriority(.required, for: .horizontal)
        temperatureStackview.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func configureMaxTemperatureLabel() {
        maxTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        maxTemperatureLabel.textColor = .systemOrange
    }
    
    private func configureMinTemperatureLabel() {
        separatorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        separatorLabel.textColor = .secondaryLabel
        separatorLabel.text = "|"
    }
    
    private func configureSeparatorLabel() {
        minTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        minTemperatureLabel.textColor = .systemBlue
    }
}

// MARK: Misc
extension MinMaxTemperatureView {
    internal func viewModelUpdated() {
        maxTemperatureLabel.text = viewModel?.maxTemperature
        minTemperatureLabel.text = viewModel?.minTemperature
        
        maxTemperatureLabel.isHidden = maxTemperatureLabel.text == nil
        minTemperatureLabel.isHidden = minTemperatureLabel.text == nil
        separatorLabel.isHidden = maxTemperatureLabel.isHidden || minTemperatureLabel.isHidden
    }
}
