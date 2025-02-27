import Foundation
import CoreLocation
import SwiftData

@Model
class GeoLocation {
    var name: String
    var streetName: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    var latitude: Double
    var longitude: Double
    
    init(name: String = "",
         streetName: String = "",
         city: String = "",
         state: String = "",
         postalCode: String = "",
         country: String = "",
         latitude: Double = 0.0,
         longitude: Double = 0.0
    ) {
        self.name = name
        self.streetName = streetName
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(with placemark: CLPlacemark, longitude: Double, latitude: Double) {
        self.init(
            name: placemark.name ?? "",
            streetName: placemark.thoroughfare ?? "",
            city: placemark.locality ?? "",
            state: placemark.administrativeArea ?? "",
            postalCode: placemark.postalCode ?? "",
            country: placemark.country ?? "",
            latitude: latitude, 
            longitude: longitude
        )
    }
}

