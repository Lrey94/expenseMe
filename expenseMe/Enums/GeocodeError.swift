//
//  GeocodeError.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 25/06/2024.
//

import Foundation

enum GeocodeError: Error {
    case badGeocode
    case nilPlacemark
}
