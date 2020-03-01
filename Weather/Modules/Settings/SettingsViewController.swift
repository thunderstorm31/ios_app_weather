import UIKit
import MessageUI
import SafariServices

internal final class SettingsViewController: UIViewController {
    private lazy var rootView = View(viewModel: self.viewModel)
    private let viewModel: SettingsViewModel
    
    internal init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationItem()
        configureTableController()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationItem() {
        navigationItem.title = Localization.Settings.navigationTitle
        
        let closeBarButtonItem = UIBarButtonItem(title: Localization.Buttons.closeTitle,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(self.pressedClose(_:)))
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    private func configureTableController() {
        viewModel.tableController.contactItem.onSelect = { [weak self] in
            self?.contactSupport()
        }
        
        viewModel.tableController.helpItem.onSelect = { [weak self] in
            self?.openHelp()
        }
    }
}

// MARK: - Load view
extension SettingsViewController {
    internal override func loadView() {
        view = rootView
    }
}

// MARK: - User Interaction
extension SettingsViewController {
    @objc
    private func pressedClose(_ sender: UIBarButtonItem) {
        viewModel.requestClose?()
    }
    
    private func contactSupport() {
        let viewController = MFMailComposeViewController()
        viewController.setSubject("I have a question about your app: Weather")
        viewController.setToRecipients(["sareninden@gmail.com"])
        viewController.mailComposeDelegate = self
        
        present(viewController, animated: true)
    }
    
    private func openHelp() {
        guard let url = URL(string: "https://www.sareninden.nl/weather/help.html") else {
            return
        }
        
        let viewController = SFSafariViewController(url: url)
        
        present(viewController, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
