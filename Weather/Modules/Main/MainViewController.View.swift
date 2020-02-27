import UIKit
import MapKit

extension MainViewController {
    @objc(MainViewControllerView) 
    internal final class View: UIView {
        private let mapView = MKMapView()
        
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
        [mapView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.pinEdgesToSuperview()
    }
}

// MARK: Layout Views
extension MainViewController.View {
    internal override func layoutSubviews() {
        super.layoutSubviews()
    }
}
