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
    @Relationship var geolocationMetadata: GeoLocation?

    init(expenseID: UUID = UUID(), 
         expenseName: String,
         expenseAmount: Double,
         image: Data? = nil,
         expenseImageDate: Date? = nil,
         geolocationMetadata: GeoLocation? = nil
    ) {
        self.expenseID = expenseID
        self.expenseName = expenseName
        self.expenseAmount = expenseAmount
        self.image = image
        self.expenseImageDate = expenseImageDate
        self.geolocationMetadata = geolocationMetadata
    }
}
