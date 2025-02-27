import Foundation
import CoreLocation

class MockLocationManager: LocationManaging {

    var shouldReturnError: Bool = false
    var mockPlacemark: CLPlacemark?

    func reverseGeoCodeLocation(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "LocationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
            completion(nil, error)
        } else {
            completion(mockPlacemark, nil)
        }
    }
}
