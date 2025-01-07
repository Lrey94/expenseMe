//
//  Expense.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import Foundation
import SwiftData
import UIKit
import MapKit

@Model
class Expense {
    @Attribute(.unique) var expenseID = UUID()
    @Attribute(.externalStorage) var image: Data?
    var expenseName: String
    var expenseAmount: Double
    var expenseImageDate: Date?
    var expenseImageLatitude: Double?
    var expenseImageLongitude: Double?
    
    init(expenseID: UUID = UUID(), expenseName: String, expenseAmount: Double, image: Data? = nil, expenseImageDate: Date? = nil, expenseImageLatitude: Double = 0.0, expenseImageLongitude: Double = 0.0) {
        self.expenseID = expenseID
        self.expenseName = expenseName
        self.expenseAmount = expenseAmount
        self.image = image
        self.expenseImageDate = expenseImageDate
        self.expenseImageLatitude = expenseImageLatitude
        self.expenseImageLongitude = expenseImageLongitude
    }
}
