//
//  AddExpenseViewModel.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 08/04/2024.
//

import Foundation
import UIKit
import SwiftData

class AddExpenseViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isConfirmationDialogPresented = false
    @Published var isImagePickerPresented = false
    @Published var sourceType: SourceType = .camera
    @Published var expenseName: String = ""
    @Published var expenseAmount: Double = 0.0
    
    @Published var showErrorMessage = false
    @Published var shouldDismiss = false
    @Published var errorMessage = ""
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addExpenseItem() -> Bool {
        if image != nil {
            if validateExpenseItem() {
                let imageData = image?.jpegData(compressionQuality: 1)
                let expenseItem = Expense(expenseName: expenseName, expenseAmount: expenseAmount, image: imageData)
                modelContext.insert(expenseItem)
                return true
            } else {
                self.showErrorMessage = true
                self.errorMessage = "Check the details you have entered"
                return false
            }
        } else {
            self.showErrorMessage = true
            self.errorMessage = "Please select or take an image"
            return false
        }
    }
    
    private func validateExpenseItem() -> Bool {
        if expenseName.isEmpty, expenseAmount == 0.0 {
            return false
        }
        return true
    }
}
