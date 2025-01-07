//
//  GeoLocation.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 25/06/2024.
//

import Foundation
import CoreLocation

struct GeoLocation {
    let name: String
    let streetName: String
    let city: String
    let state: String
    let postalCode: String
    let country: String
    
    init(with placemark: CLPlacemark) {
        self.name = placemark.name ?? ""
        self.streetName = placemark.thoroughfare ?? ""
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.postalCode = placemark.postalCode ?? ""
        self.country = placemark.country ?? ""
    }
}
