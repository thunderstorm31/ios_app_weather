import UIKit
import MapKit

extension HomeViewController {
    @objc(HomeViewControllerView) 
    internal final class View: UIView {
        internal let mapView = MKMapView()
        
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
        [mapView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.pinEdgesToSuperview()
    }
}
