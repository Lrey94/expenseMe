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
        } catch {
            print("Unable to fetch expenses: \(error)")
        }
    }
    
}
