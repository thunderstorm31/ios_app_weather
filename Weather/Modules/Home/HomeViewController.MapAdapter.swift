import MapKit

extension HomeViewController {
    internal final class MapAdapter: NSObject {
        internal var selectedCity: ((City) -> Void)?
        
        private let services: Services
        private var citiesService: CitiesService { services.get(CitiesService.self) }
        
        internal init(services: Services = .default) {
            self.services = services
            
            super.init()
        }
    }
}

extension HomeViewController.MapAdapter: MKMapViewDelegate {    
    internal func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let selectedCity = selectedCity, let annotation = view.annotation else {
            return
        }
        
        if let city = (annotation as? HomeViewMapAnnotation)?.city {
            selectedCity(city)
        } else {
            let request = CityLocationRequest(coordinate: annotation.coordinate, limit: 1, maxDistance: 15_000)
            
            citiesService.citiesFor(request) { cities in
                if let city = cities.first {
                    selectedCity(city)
                }
            }
        }
    }
}
