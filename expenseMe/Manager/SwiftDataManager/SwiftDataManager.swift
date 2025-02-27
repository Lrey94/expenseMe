import Foundation
import SwiftData

final class SwiftDataManager: ObservableObject, SwiftDataManaging {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchExpenses() -> [Expense]? {
        let fetchDescriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.expenseID)]
        )
        do {
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Unable to fetch expenses: \(error)")
            return nil
        }
    }
    
    func insertExpense(expense: Expense, completion: @escaping (Bool) -> Void) {
        modelContext.insert(expense)
        do {
            try modelContext.save()
            completion(true)
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteExpense(expense: Expense) {
        modelContext.delete(expense)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
        }
    }
    
}
