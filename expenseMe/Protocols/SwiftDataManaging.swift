import Foundation

protocol SwiftDataManaging {
    func fetchExpenses() -> [Expense]?
    func insertExpense(expense: Expense, completion: @escaping (Bool) -> Void)
    func deleteExpense(expense: Expense)
}
