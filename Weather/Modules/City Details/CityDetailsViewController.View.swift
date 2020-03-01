import UIKit

extension CityDetailsViewController {
    @objc(CityDetailsViewControllerView)
    internal final class View: UIView {
        private let tableView = UITableView(frame: .main)
        private let closeButtonGradientView = GradientView()
        
        private let viewModel: CityDetailsViewModel
        
        internal let closeButton = UIButton()
        
        internal init(viewModel: CityDetailsViewModel) {
            self.viewModel = viewModel
            
            super.init(frame: .main)
            
            configureViews()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Configure Views
extension CityDetailsViewController.View {
    private func configureViews() {        
        [tableView, closeButtonGradientView, closeButton]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureTableView()
        configureCloseButtonGradientView()
        configureCloseButton()
    }
    
    private func configureTableView() {
        tableView.pinEdgesToSuperview()
        
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.contentInset.bottom = 20
        
        viewModel.tableAdapter.configure(tableView)
    }
    
    private func configureCloseButtonGradientView() {
        closeButtonGradientView.pinTopToSuperview()
        closeButtonGradientView.pinTrailingToSuperview()
        closeButtonGradientView.pinWidth(with: closeButton, multiplier: 5)
        closeButtonGradientView.pinHeight(with: closeButton, multiplier: 2)
        
        closeButtonGradientView.colors = [
            UIColor.systemBackground,
            UIColor.systemBackground,
            UIColor.systemBackground.withAlphaComponent(0),
            UIColor.systemBackground.withAlphaComponent(0)
        ]
        
        closeButtonGradientView.startPoint = CGPoint(x: 1, y: 0)
        closeButtonGradientView.endPoint = CGPoint(x: 0, y: 1)
        closeButtonGradientView.locations = [0, 0.4, 0.5, 1]
    }
    
    private func configureCloseButton() {
        closeButton.pin(height: 44)
        closeButton.pinTopToSuperview(padding: 5, layoutArea: .safeArea)
        closeButton.pinTrailingToSuperview(layoutArea: .layoutMargins)
        
        closeButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitle(Localization.Buttons.closeTitle, for: .normal)
    }
}

// MARK: - Misc
extension CityDetailsViewController.View {
    internal func reloadData() {
        tableView.reloadData()
    }
}
