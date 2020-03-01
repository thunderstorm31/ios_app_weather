import CoreLocation

internal protocol DeviceLocationServiceDelegate: AnyObject {
    func deviceLocationServiceUpdatedAuthorization(_ service: DeviceLocationService)
    func deviceLocationService(_ service: DeviceLocationService, received locations: [CLLocation])
}

extension DeviceLocationServiceDelegate {
    internal func deviceLocationServiceUpdatedAuthorization(_ service: DeviceLocationService) {}
    internal func deviceLocationService(_ service: DeviceLocationService, received locations: [CLLocation]) {}
}

internal protocol DeviceLocationService: Service {
    var canRequestLocationAccess: Bool { get }
    var isAuthorized: Bool { get }
    
    func requestLocationAccess()
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    func addDelegate(_ delegate: DeviceLocationServiceDelegate)
    func removeDelegate(_ delegate: DeviceLocationServiceDelegate)
}
