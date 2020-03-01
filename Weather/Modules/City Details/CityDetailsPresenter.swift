import UIKit

internal final class CityDetailsPresenter {
    private let city: City
    
    internal init(city: City) {
        self.city = city
    }
    
    internal func presentFrom(_ presenter: UIViewController) {
        let viewModel = CityDetailsViewModel(city: city)
        let viewController = CityDetailsViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .formSheet
        
        presenter.present(viewController, animated: true)
    }
}
