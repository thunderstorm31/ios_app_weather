import UIKit

internal final class CityViewController: UIViewController {
    private let viewModel: CityViewModel
    private lazy var rootView = View(viewModel: self.viewModel)
    
    private let searchBar = UISearchBar()
    
    internal init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationItem()
        configureViewModel()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationItem() {
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tappedCancel(_:)))
    }
    
    private func configureViewModel() {
        viewModel.searchCityTableAdapter.selectedCity = { [weak self] city in
            self?.selectedSearchedCity(city)
        }
        
        viewModel.storedCityAdapter.selectedCity = { [weak self] city in
            self?.selectedStoredCity(city)
        }
    }
    
    private func selectedSearchedCity(_ city: City) {
        viewModel.selectedSearchedCity(city)
        searchBar.resignFirstResponder()
    }
    
    private func selectedStoredCity(_ city: City) {
        viewModel.selectedStoredCity(city)
        dismiss(animated: true)
    }
}

// MARK: Load view
extension CityViewController {
    internal override func loadView() {
        view = rootView
    }
}

// MARK: Life cycle
extension CityViewController {
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.storedCityAdapter.setActive(rootView.tableView)
    }
}

// MARK: UISearchBarDelegate
extension CityViewController: UISearchBarDelegate {
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCityTableAdapter.setActive(rootView.tableView)
    }

    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.storedCityAdapter.setActive(rootView.tableView)
    }

    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performQuery(searchText) { [rootView] in
            rootView.tableView.reloadData()
        }
    }
}

// MARK: User Interaction
extension CityViewController {
    @objc
    private func tappedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
