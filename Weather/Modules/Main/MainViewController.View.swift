import UIKit
import MapKit

extension MainViewController {
    @objc(MainViewControllerView) 
    internal final class View: UIView {
        private let mapView = MKMapView()
        
        internal let locationsButton = MainMenuButton()
        internal let settingsButton = MainMenuButton()
        
        internal init() {
            super.init(frame: UIScreen.main.bounds)
            
            configureViews()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: Configure Views
extension MainViewController.View {
    private func configureViews() {
        [mapView, locationsButton, settingsButton]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureMapView()
        configureLocationsButton()
        configureSettingsButton()
    }
    
    private func configureMapView() {
        mapView.pinEdgesToSuperview()
    }
    
    private func configureLocationsButton() {
        locationsButton.pinTopToSuperview(layoutArea: .layoutMargins)
        locationsButton.pinLeadingToSuperview(layoutArea: .layoutMargins)
        locationsButton.pin(singleSize: 44)
        
        locationsButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    }
    
    private func configureSettingsButton() {
        settingsButton.pinTopToSuperview(layoutArea: .layoutMargins)
        settingsButton.pinTrailingToSuperview(layoutArea: .layoutMargins)
        settingsButton.pin(singleSize: 44)
        
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
    }
}
