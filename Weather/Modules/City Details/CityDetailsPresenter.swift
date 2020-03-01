import UIKit

internal final class CityDetailsPresenter {
    private let city: City
    
    internal init(city: City) {
        self.city = city
    }
    
    internal func presentFrom(_ presenter: UIViewController) {
        let viewModel = CityDetailsViewModel(city: city)
        let viewController = CityDetailsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .formSheet
        
        presenter.present(navigationController, animated: true)
    }
}
