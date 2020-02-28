import UIKit
import MapKit

extension HomeViewController {
    @objc(HomeViewControllerView) 
    internal final class View: UIView {
        internal let mapView = MKMapView()
        
        internal let locationsButton = HomeMenuButton()
        internal let settingsButton = HomeMenuButton()
        
        internal init() {
            super.init(frame: .main)
            
            configureViews()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: Configure Views
extension HomeViewController.View {
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
