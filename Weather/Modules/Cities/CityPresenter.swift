import UIKit

internal final class CityPresenter {
    internal func presentFrom(_ presenter: UIViewController, selectedCity: @escaping CityViewModel.SelectedCity) {
        let viewModel = CityViewModel(selectedCity: selectedCity)
        let viewController = CityViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .formSheet
        
        presenter.present(navigationController, animated: true)
    }
}
