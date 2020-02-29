import UIKit

internal final class CityDetailsHourlyForecastCell: UITableViewCell {
    internal struct ViewModel {
        internal let dayItem: HourlyForecasts.DayItem
    }
    
    private var viewModel: ViewModel? {
        didSet { updatedViewModel() }
    }
    
    private let hourDateFormatter = DateFormatter()
    private let flowLayout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView
    private let leftGradientView = GradientView()
    private let rightGradientView = GradientView()
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        hourDateFormatter.dateFormat = "HH"
        
        configureViews()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setViewModel(_ viewModel: ViewModel) -> CityDetailsHourlyForecastCell {
        self.viewModel = viewModel
        return self
    }
    
    private func updatedViewModel() {}
}

// MARK: Configure Views
extension CityDetailsHourlyForecastCell {
    private func configureViews() {
        [collectionView, leftGradientView, rightGradientView]
            .disableTranslateAutoresizingMask()
            .add(to: contentView)
        
        configureCollectionView()
        configureLeftGradientView()
        configureRightGradientView()
    }
    
    private func configureCollectionView() {
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        
        collectionView.register(cell: CityDetailsHourlyWeatherCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(horizontal: 20, vertical: 5)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.pinEdgesToSuperview()
        collectionView.pin(height: 100)
    }
    
    private func configureLeftGradientView() {
        leftGradientView.pinEdgesToSuperview(excludeEdges: .trailing)
        leftGradientView.pin(width: 20)
        leftGradientView.startPoint = CGPoint(x: 0, y: 0.5)
        leftGradientView.endPoint = CGPoint(x: 1, y: 0.5)
        leftGradientView.colors = gradientColors
        leftGradientView.locations = gradientLocations
    }
    
    private func configureRightGradientView() {
        rightGradientView.pinEdgesToSuperview(excludeEdges: .leading)
        rightGradientView.pin(width: 20)
        rightGradientView.startPoint = CGPoint(x: 1, y: 0.5)
        rightGradientView.endPoint = CGPoint(x: 0, y: 0.5)
        rightGradientView.colors = gradientColors
        rightGradientView.locations = gradientLocations
    }
    
    private var gradientColors: [UIColor] { [.systemBackground, .systemBackground, .init(white: 1, alpha: 0)] }
    private var gradientLocations: [NSNumber] { [0, 0.2, 1] }
}

// MARK: UICollectionViewDelegate
extension CityDetailsHourlyForecastCell: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool { false }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CityDetailsHourlyForecastCell: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.bounds.height - collectionView.contentInset.vertical
        
        return CGSize(width: length, height: length)
    }
}

// MARK: UICollectionViewDataSource
extension CityDetailsHourlyForecastCell: UICollectionViewDataSource {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel?.dayItem.hourlyItems.count ?? 0 }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: CityDetailsHourlyWeatherCell.self, indexPath: indexPath)
        
        if let hourlyItem = viewModel?.dayItem.hourlyItems[safe: indexPath.item] {
            let hourText = hourDateFormatter.string(from: hourlyItem.date)
            let temperatureText = temperatureString(forTemperature: hourlyItem.weatherDetails.temperature)

            let symbolName = WeatherIdToSymbolHelper.symbolName(for: hourlyItem.weather.first?.id ?? 0, isDayTime: true)
            
            let icon = UIImage(systemName: symbolName)
                        
            let viewModel = CityDetailsHourlyWeatherCell.ViewModel(hourText: hourText, temperatureText: temperatureText, icon: icon)

            cell.setViewModel(viewModel)
        }
                
        return cell
    }
    
    private func temperatureString(forTemperature temperature: Double?) -> String? {
        if let temperature = temperature {
            return "\(Int(round(temperature)))°"
        } else {
            return nil
        }
    }
}
