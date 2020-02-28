import UIKit

internal final class SettingsViewController: UIViewController {
    private lazy var rootView = View(viewModel: self.viewModel)
    private let viewModel: SettingsViewModel
    
    internal init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationItem()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationItem() {
        navigationItem.title = Localization.Settings.navigationTitle
        
        let closeBarButtonItem = UIBarButtonItem(title: Localization.Buttons.closeTitle,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(self.pressedClose(_:)))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
}

// MARK: Load view
extension SettingsViewController {
    internal override func loadView() {
        view = rootView
    }
}

// MARK: User Interaction
extension SettingsViewController {
    @objc
    private func pressedClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
