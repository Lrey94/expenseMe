import Foundation
import SwiftData

class HomeViewModel: ObservableObject {

    @Published var expenses: [Expense] = []
    @Published var runningExpenseTotal: Double = 0

    let swiftDataManager: SwiftDataManager

    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }

    func fetchExpenses() {
        if let expenses = swiftDataManager.fetchExpenses() {
            self.expenses = expenses
            if !expenses.isEmpty {
                calculateTotalExpenseAmount()
            }
        }
    }
    
    private func calculateTotalExpenseAmount() {
        self.runningExpenseTotal = 0.0
        for expense in expenses {
            self.runningExpenseTotal += expense.expenseAmount
        }
    }
}
