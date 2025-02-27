import Foundation
import CoreLocation

protocol LocationManaging {
    func reverseGeoCodeLocation(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void)
}
