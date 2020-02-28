import UIKit

extension SettingsViewController {
    @objc(SettingsViewControllerView) 
    internal final class View: UIView {
        private let viewModel: SettingsViewModel
        private let tableView = UITableView(frame: .main, style: .grouped)
        
        internal init(viewModel: SettingsViewModel) {
            self.viewModel = viewModel
            
            super.init(frame: .main)
            
            configureViews()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: Configure Views
extension SettingsViewController.View {
    private func configureViews() {
        [tableView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        backgroundColor = .systemGroupedBackground
        
        viewModel.tableController.configure(tableView)
    }
}
