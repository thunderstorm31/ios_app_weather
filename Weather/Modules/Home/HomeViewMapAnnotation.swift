import MapKit

internal protocol HomeViewMapAnnotationDelegate: AnyObject {
    func weatherUpdated(annotation: HomeViewMapAnnotation)
}

internal final class HomeViewMapAnnotation: NSObject {
    internal let city: City
    internal var weather: TodayWeather? {
        didSet { delegate?.weatherUpdated(annotation: self) }
    }
    
    internal weak var delegate: HomeViewMapAnnotationDelegate?
    
    internal init(city: City) {
        self.city = city
    }
}

// MARK: - MKAnnotation
extension HomeViewMapAnnotation: MKAnnotation {
    internal var coordinate: CLLocationCoordinate2D { city.coordinates.coordinate }
    internal var title: String? { city.name }
}
