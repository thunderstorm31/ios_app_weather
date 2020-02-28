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
        mapAdapter.selectedCity = { [weak self] _ in }
    }
}

// MARK: - Load view
extension HomeViewController {
    internal override func loadView() {
        view = rootView
        
        rootView.locationsButton.addTarget(self, action: #selector(self.tappedLocationButton(_:)), for: .touchUpInside)
        rootView.mapView.delegate = mapAdapter
        
        let addCityRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addLocation(_:)))
        
        rootView.mapView.addGestureRecognizer(addCityRecognizer)
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
    private func tappedLocationButton(_ sender: UIButton) {
        let presenter = CityPresenter()
        
        presenter.presentFrom(self)
    }
    
    @objc
    private func addLocation(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: rootView.mapView)
        let coordinate = rootView.mapView.convert(point, toCoordinateFrom: nil)
        
        viewModel.addCity(forCoordinate: coordinate) { [weak self] result in
            self?.addedCityResult(result)
        }
    }
    
    private func addedCityResult(_ result: HomeViewModel.AddCityResult) {
        switch result {
        case .added:
            break
        case .alreadyAdded:
            break
        case .notFound:
            break
        }
    }
}

// MARK: - Map
extension HomeViewController {
    private func updateAnnotations(with cities: [City]) {
        rootView.mapView.removeAnnotations(rootView.mapView.annotations)
        
        let annotations = cities.map { HomeViewMapAnnotation(city: $0) }
        
        rootView.mapView.addAnnotations(annotations)
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    internal func updatedCities(_ cities: [City]) {
        updateAnnotations(with: cities)
    }
    
    internal func updatedSelectedCity(_ city: [City]) {}
}
