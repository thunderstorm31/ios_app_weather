import UIKit

internal final class CityDetailsViewController: UIViewController {
    private lazy var rootView = View(viewModel: self.viewModel)
    
    private let viewModel: CityDetailsViewModel
    
    internal init(viewModel: CityDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureNaviationItem()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNaviationItem() {
        let closeBarButtonItem = UIBarButtonItem(title: Localization.Buttons.closeTitle,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(self.tappedClose(_:)))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
}

// MARK: - Load view
extension CityDetailsViewController {
    internal override func loadView() {
        view = rootView
        
        rootView.closeButton.addTarget(self, action: #selector(self.tappedClose(_:)), for: .touchUpInside)
    }
}

// MARK: - Life cycle
extension CityDetailsViewController {
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
}

// MARK: - User Interaction
extension CityDetailsViewController {
    @objc
    private func tappedClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - CityDetailsViewModelDelegate
extension CityDetailsViewController: CityDetailsViewModelDelegate {
    internal func cityDetailsViewModel(_ model: CityDetailsViewModel, updated state: CityDetailsViewModel.State) {
        rootView.reloadData()
    }
}
