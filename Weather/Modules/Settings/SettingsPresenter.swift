import UIKit

internal final class SettingsPresenter {
    internal func presentFrom(_ presenter: UIViewController) {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presenter.present(navigationController, animated: true)
    }
}
