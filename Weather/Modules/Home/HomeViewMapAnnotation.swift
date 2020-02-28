import MapKit

internal final class HomeViewMapAnnotation: NSObject {
    internal let city: City
    
    internal init(city: City) {
        self.city = city
    }
}

// MARK: - MKAnnotation
extension HomeViewMapAnnotation: MKAnnotation {
    internal var coordinate: CLLocationCoordinate2D { city.location.coordinate }
    internal var title: String? { city.name }
}
