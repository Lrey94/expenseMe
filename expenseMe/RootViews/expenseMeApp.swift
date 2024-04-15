//
//  expenseMeApp.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import SwiftUI
import SwiftData

@main
struct expenseMeApp: App {
    
    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var addExpenseViewModel: AddExpenseViewModel
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Expense.self)
            let modelContext = modelContainer.mainContext
            
            _addExpenseViewModel = StateObject(wrappedValue: AddExpenseViewModel(modelContext: modelContext))
            _homeViewModel = StateObject(wrappedValue: HomeViewModel(modelContext: modelContext))
        } catch {
            fatalError("Could not initialize ModelContainer when launching app")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
                .environmentObject(addExpenseViewModel)
        }
        .modelContainer(modelContainer)
    }
}
