import CoreLocation

internal final class DeviceLocationManager: NSObject, DeviceLocationService {
    private let locationManager = CLLocationManager()
    private let delegates = WeakHashTable<DeviceLocationServiceDelegate>()
    
    internal var canRequestLocationAccess: Bool {
        CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    internal var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    internal override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    internal func requestLocationAccess() {
        guard canRequestLocationAccess else {
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    internal func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    internal func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    internal func addDelegate(_ delegate: DeviceLocationServiceDelegate) {
        delegates.add(delegate)
    }
    
    internal func removeDelegate(_ delegate: DeviceLocationServiceDelegate) {
        delegates.remove(delegate)
    }
}

// MARK: CLLocationManagerDelegate
extension DeviceLocationManager: CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.isNotEmpty else {
            return
        }
        
        delegates.forEach { $0.deviceLocationService(self, received: locations) }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegates.forEach { $0.deviceLocationServiceUpdatedAuthorization(self) }
    }
}
