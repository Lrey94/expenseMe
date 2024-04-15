//
//  Expense.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import Foundation
import SwiftData
import UIKit

@Model
class Expense {
    @Attribute(.unique) var expenseID = UUID()
    var expenseName: String
    var expenseAmount: Double
    var image: Data?
    
    init(expenseID: UUID = UUID(), expenseName: String, expenseAmount: Double, image: Data? = nil) {
        self.expenseID = expenseID
        self.expenseName = expenseName
        self.expenseAmount = expenseAmount
        self.image = image
    }
}
