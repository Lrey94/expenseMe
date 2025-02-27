import Foundation
import MapKit
import CoreLocation

extension CLPlacemark {
    public static func mock(coordinate: CLLocationCoordinate2D, name: String) -> CLPlacemark {
        let mkPlacemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: ["name" : name]
        )
        return CLPlacemark(placemark: mkPlacemark)
    }
}
