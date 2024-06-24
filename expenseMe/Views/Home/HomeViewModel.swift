//
//  HomeViewModel.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 08/04/2024.
//

import Foundation
import SwiftData

class HomeViewModel: ObservableObject {
    
    @Published var expenses: [Expense] = []
    @Published var runningExpenseTotal: Double = 0
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchExpenses() {
        let fetchDescriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.expenseID)]
        )
        do {
            expenses = try modelContext.fetch(fetchDescriptor)
            if !expenses.isEmpty {
                calculateTotalExpenseAmount()
            }
        } catch {
            print("Unable to fetch expenses: \(error)")
        }
    }
    
    private func calculateTotalExpenseAmount() {
        self.runningExpenseTotal = 0.0
        for expense in expenses {
            self.runningExpenseTotal += expense.expenseAmount
        }
    }
    
}
