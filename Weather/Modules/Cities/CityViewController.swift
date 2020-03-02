import UIKit

internal final class CityViewController: UIViewController {
    private let viewModel: CityViewModel
    private lazy var rootView = View(viewModel: self.viewModel)
        
    private let searchBar = UISearchBar()
    private let deleteAllBarButtonItem = UIBarButtonItem(title: Localization.Buttons.deleteAllTitle, style: .plain, target: nil, action: nil)
    
    private let cancelBarButtonItem = UIBarButtonItem(title: Localization.Buttons.cancelTitle, style: .plain, target: nil, action: nil)
    private let closeBarButtonItem = UIBarButtonItem(title: Localization.Buttons.closeTitle, style: .plain, target: nil, action: nil)
    
    internal init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationItem()
        configureDeleteAllBarButtonItem()
        configureViewModel()
        
        updateToolBarItems()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationItem() {
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
        closeBarButtonItem.target = self
        closeBarButtonItem.action = #selector(self.tappedClose(_:))
        
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(self.tappedCancel(_:))
    }
    
    private func configureDeleteAllBarButtonItem() {
        deleteAllBarButtonItem.target = self
        deleteAllBarButtonItem.action = #selector(self.tappedDeleteAll(_:))
        deleteAllBarButtonItem.tintColor = .systemRed
    }
    
    private func configureViewModel() {
        viewModel.searchCityTableAdapter.selectedCity = { [weak self] city in
            self?.searchBar.resignFirstResponder()
            self?.searchBar.text = nil
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
    }
    
    internal override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        rootView.tableView.setEditing(editing, animated: animated)
        updateToolBarItems()
    }
    
    private func updateToolBarItems() {
        var items = [editButtonItem, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        
        if isEditing {
            items.append(deleteAllBarButtonItem)
        }
        
        toolbarItems = items
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
        viewModel.viewDidLoad()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    internal func willDismiss() {
        searchBar.resignFirstResponder()
    }
    
    internal func didDismiss() {
        setEditing(false, animated: false)
        searchBar.text = nil
    }
}

// MARK: UISearchBarDelegate
extension CityViewController: UISearchBarDelegate {
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCityTableAdapter.setActive(rootView.tableView)
        
        navigationController?.setToolbarHidden(true, animated: true)
        navigationItem.setRightBarButton(cancelBarButtonItem, animated: true)
        
        setEditing(false, animated: true)
    }

    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.storedCityAdapter.setActive(rootView.tableView)
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationItem.setRightBarButton(closeBarButtonItem, animated: true)
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
    private func tappedClose(_ sender: UIBarButtonItem) {
        viewModel.requestClose?()
    }
    
    @objc
    private func tappedCancel(_ sender: UIBarButtonItem) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    @objc
    private func tappedDeleteAll(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: Localization.Alerts.deleteAllTitle,
                                                message: Localization.Alerts.deleteAllMessage,
                                                preferredStyle: .actionSheet)
        
        let deleteAllAction = UIAlertAction(title: Localization.Buttons.deleteAllTitle, style: .destructive) { _ in
            self.deleteAll()
        }
        let cancelAction = UIAlertAction(title: Localization.Buttons.cancelTitle, style: .cancel)
        
        alertController.addAction(deleteAllAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.barButtonItem = sender
        
        present(alertController, animated: true)
    }
    
    private func deleteAll() {
        viewModel.deleteAll()
        rootView.tableView.reloadData()
        setEditing(false, animated: true)
    }
}
