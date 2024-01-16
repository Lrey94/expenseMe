//
//  ContentView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var expenseViewModel = ExpenseViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Expense Me")
                        .font(.title)
                        .fontWeight(.medium)
                        .shadow(radius: 2)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                if expenseViewModel.expenses.isEmpty {
                    ContentUnavailableView("No Expenses", systemImage: "banknote.fill", description: Text("Add a new one to get started."))
                        .padding(.bottom, 50)
                }
                
                Spacer()
            }
            .toolbar {
                NavigationLink {
                    AddExpenseView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
