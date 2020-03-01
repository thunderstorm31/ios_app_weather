import UIKit

internal final class CityDetailsCityCell: CityDetailsTableCell {
    internal struct ViewModel {
        internal let cityName: String
        internal let currentCondition: String?
        internal let temperature: String?
    }
    
    private let cityNameLabel = UILabel()
    
    private let detailsStackView = UIStackView()
    private let currentConditionLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let separatorLabel = UILabel()
    
    internal private(set) var viewModel: ViewModel? {
        didSet { updatedViewModel() }
    }
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    internal func setViewModel(_ viewModel: ViewModel) -> CityDetailsCityCell {
        self.viewModel = viewModel
        
        return self
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func configureViews() {
        [cityNameLabel, detailsStackView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        detailsStackView.addArrangedSubview(temperatureLabel)
        detailsStackView.addArrangedSubview(separatorLabel)
        detailsStackView.addArrangedSubview(currentConditionLabel)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
        configureCityNameLabel()
        configureDetailsStackView()
        configureTemperatureLabel()
        configureSeparatorLabel()
        configureCurrentConditionLabel()
    }
    
    private func configureCityNameLabel() {
        cityNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        cityNameLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        cityNameLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        cityNameLabel.pinTopToSuperview(layoutArea: .layoutMargins)
        
        cityNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    private func configureDetailsStackView() {
        detailsStackView.pin(below: cityNameLabel)
        detailsStackView.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        detailsStackView.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        detailsStackView.pinBottomToSuperview(layoutArea: .layoutMargins)
        
        detailsStackView.axis = .horizontal
        detailsStackView.alignment = .center
        detailsStackView.spacing = 5
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        temperatureLabel.textColor = .systemOrange
    }
    
    private func configureSeparatorLabel() {
        separatorLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        separatorLabel.textColor = .secondaryLabel
        separatorLabel.text = "|"
    }
    
    private func configureCurrentConditionLabel() {
        currentConditionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        currentConditionLabel.textColor = .label
    }
}

// MARK: Configure Views
extension CityDetailsCityCell {
    private func updatedViewModel() {
        cityNameLabel.text = viewModel?.cityName
        currentConditionLabel.text = viewModel?.currentCondition
        temperatureLabel.text = viewModel?.temperature
        
        currentConditionLabel.isHidden = currentConditionLabel.text == nil
        temperatureLabel.isHidden = temperatureLabel.text == nil
        
        separatorLabel.isHidden = currentConditionLabel.isHidden || temperatureLabel.isHidden
    }
}
