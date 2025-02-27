import Foundation

@testable import expenseMe

class MockSwiftDataManager: SwiftDataManaging {
    
    var mockExpenseList: [Expense] = []
    var shouldFail = false
    
    func fetchExpenses() -> [Expense]? {
        return shouldFail ? nil : mockExpenseList
    }
    
    func insertExpense(expense: Expense, completion: @escaping (Bool) -> Void) {
        if shouldFail {
            completion(false)
        } else {
            mockExpenseList.append(expense)
            completion(true)
        }
    }
    
    func deleteExpense(expense: Expense) {
        if let expenseIndex = mockExpenseList.firstIndex(where: { $0.expenseID == expense.expenseID }) {
            self.mockExpenseList.remove(at: expenseIndex)
        }
    }
}
