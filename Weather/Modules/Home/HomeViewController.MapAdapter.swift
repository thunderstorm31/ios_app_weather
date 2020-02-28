import MapKit

extension HomeViewController {
    internal final class MapAdapter: NSObject {
        internal var selectedCity: ((City) -> Void)?
    }
}

extension HomeViewController.MapAdapter: MKMapViewDelegate {
    internal func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? HomeViewMapAnnotation else {
            return
        }
        
        selectedCity?(annotation.city)
    }
}
