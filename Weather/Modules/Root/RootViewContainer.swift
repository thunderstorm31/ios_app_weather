import UIKit

internal final class RootViewContainer: UIView {
    private let contentContainer = UIView()
    
    private var contentViewController: UIViewController
    
    internal init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        
        super.init(frame: .zero)
        
        configureViews()
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewContainer {
    private func configureViews() {
        [contentContainer]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureLayer()
        configureContentContainer()
        configureContentViewController()
    }
    
    private func configureLayer() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    private func configureContentContainer() {
        contentContainer.pinEdgesToSuperview()
        contentContainer.layer.cornerRadius = 16
        contentContainer.layer.masksToBounds = true
        contentContainer.backgroundColor = .systemBackground
    }
    
    private func configureContentViewController() {
        contentContainer.addSubview(contentViewController.view.disableTranslateAutoresizingMask())
        contentViewController.view.pinEdgesToSuperview()
    }
}
