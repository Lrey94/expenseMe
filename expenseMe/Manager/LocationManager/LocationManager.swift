import Foundation
import CoreLocation

final class LocationManager: LocationManaging {
        
    func reverseGeoCodeLocation(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion(nil, error)
            } else if let placemark = placemarks?.first {
                completion(placemark, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}
