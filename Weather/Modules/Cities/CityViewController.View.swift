import UIKit

extension CityViewController {
    @objc(CityViewControllerView) 
    internal final class View: UIView {
        private let viewModel: CityViewModel
        
        internal let tableView = UITableView(frame: .main, style: .grouped)
        
        internal init(viewModel: CityViewModel) {
            self.viewModel = viewModel
            
            super.init(frame: .main)
            
            viewModel.delegate = self
            
            configureViews()
            
            KeyboardManager.shared.add(delegate: self)
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: Configure Views
extension CityViewController.View {
    private func configureViews() {
        [tableView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        backgroundColor = .systemGroupedBackground
        
        configureTableView()
    }
    
    private func configureTableView() {
        viewModel.searchCityTableAdapter.configure(tableView)
        viewModel.storedCityAdapter.configure(tableView)
        
        tableView.pinEdgesToSuperview()
        
        viewModel.storedCityAdapter.setActive(tableView)
    }
}

// MARK: CityViewModelDelegate
extension CityViewController.View: CityViewModelDelegate {
    internal func reloadContent() {
        tableView.reloadData()
    }
}

// MARK: KeyboardManagerDelegate
extension CityViewController.View: KeyboardManagerDelegate {
    internal func keyboardManager(_ manager: KeyboardManager, info: KeyboardManager.Info) {
        info.animate(animations: {
            let bottomInset: CGFloat
            
            switch info.displayAction {
            case .willShow, .didShow:
                bottomInset = info.endFrame.height - self.safeAreaInsets.bottom
            case .willHide, .didHide:
                bottomInset = 0
            }
            
            self.tableView.contentInset.bottom = bottomInset
            self.tableView.verticalScrollIndicatorInsets.bottom = bottomInset
        }, completion: nil)
    }
}
