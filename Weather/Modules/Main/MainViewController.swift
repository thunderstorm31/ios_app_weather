import UIKit

internal final class MainViewController: UIViewController {
    private lazy var rootView = View()
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Load view
extension MainViewController {
    internal override func loadView() {
        view = rootView
        
        rootView.locationsButton.addTarget(self, action: #selector(self.tappedLocationButton(_:)), for: .touchUpInside)
    }
}

// MARK: User Interaction
extension MainViewController {
    @objc
    private func tappedLocationButton(_ sender: UIButton) {
        let presenter = CityPresenter()
        
        presenter.presentFrom(self)
    }
}
