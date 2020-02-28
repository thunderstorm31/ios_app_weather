import UIKit

internal final class CityPresenter {
    internal func presentFrom(_ presenter: UIViewController) {
        let viewModel = CityViewModel()
        let viewController = CityViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presenter.present(navigationController, animated: true)
    }
}
