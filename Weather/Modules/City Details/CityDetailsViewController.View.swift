import UIKit

extension CityDetailsViewController {
    @objc(CityDetailsViewControllerView)
    internal final class View: UIView {
        private let tableView = UITableView(frame: .main)
        
        private let viewModel: CityDetailsViewModel
        
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
        [tableView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.pinEdgesToSuperview()
        
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.contentInset.bottom = 20
        
        viewModel.tableAdapter.configure(tableView)
    }
}

// MARK: - Misc
extension CityDetailsViewController.View {
    internal func reloadData() {
        tableView.reloadData()
    }
}
