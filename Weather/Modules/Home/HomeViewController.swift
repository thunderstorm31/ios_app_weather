import UIKit

internal final class HomeViewController: UIViewController {
    private lazy var rootView = View()
    private let viewModel: HomeViewModel
    private let mapAdapter = MapAdapter()
    
    internal init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureMapAdapter()
        
        viewModel.delegate = self
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMapAdapter() {
        mapAdapter.selectedCity = { [weak self] city in
            self?.selected(city, updateMapCenter: false)
        }
    }
}

// MARK: - Load view
extension HomeViewController {
    internal override func loadView() {
        view = rootView
        
        let addCityRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addLocation(_:)))
        
        rootView.mapView.addGestureRecognizer(addCityRecognizer)
        
        mapAdapter.configure(rootView.mapView)
    }
}

// MARK: - Life cycle
extension HomeViewController {
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
}

// MARK: - User Interaction
extension HomeViewController {    
    @objc
    private func addLocation(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        
        let point = sender.location(in: rootView.mapView)
        let coordinate = rootView.mapView.convert(point, toCoordinateFrom: nil)
        
        viewModel.addCity(for: coordinate) { [weak self] result in
            self?.addedCityResult(result)
        }
    }
    
    internal func selected(_ city: City, updateMapCenter: Bool) {
        if updateMapCenter {
            rootView.mapView.setCenter(city.coordinates.coordinate, animated: true)
        }
        
        let presenter = CityDetailsPresenter(city: city)
        
        presenter.presentFrom(self)
    }
    
    private func addedCityResult(_ result: HomeViewModel.AddCityResult) {
        switch result {
        case .added(let city):
            selected(city, updateMapCenter: false)
        case .alreadyAdded(let city):
            selected(city, updateMapCenter: false)
        case .notFound:
            let alert = UIAlertController(title: Localization.Alerts.noCityFoundTitle,
                                          message: Localization.Alerts.noCityFoundMessage,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: Localization.Buttons.okTitle, style: .default, handler: nil))
            
            present(alert, animated: true)
        }
    }
}

// MARK: - Map
extension HomeViewController {
    private func updateAnnotations(with cities: [City]) {
        rootView.mapView.removeAnnotations(rootView.mapView.annotations)
        
        let annotations = cities.map { city -> HomeViewMapAnnotation in
            let annotation = HomeViewMapAnnotation(city: city)
            
            annotation.weather = viewModel.weathers[city]
            
            return annotation
        }
        
        rootView.mapView.addAnnotations(annotations)
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    internal func updateShowUserLocationOnMap(_ show: Bool) {
        rootView.mapView.showsUserLocation = show
    }
    
    internal func updated(_ cities: [City]) {
        updateAnnotations(with: cities)
    }
    
    internal func centerOn(_ city: City) {
        rootView.mapView.setCenter(city.coordinates.coordinate, animated: true)
    }
    
    internal func updatedWeathers(_ weathers: [City: TodayWeather]) {
        rootView.mapView.annotations
            .compactMap { $0 as? HomeViewMapAnnotation }
            .forEach {
                if let weather = weathers[$0.city] {
                    $0.weather = weather
                }
            }
    }
}
