//
//  ContentView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
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

#Preview {
    ContentView()
}
