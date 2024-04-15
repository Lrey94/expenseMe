//
//  EditExpenseView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 15/04/2024.
//

import SwiftUI

struct EditExpenseView: View {
    
    static let tag = "EditExpenseView"
    
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("Edit Expense here")
    }
}

struct EditExpenseView_Preview: PreviewProvider {
    @State static var path: NavigationPath = .init()
    static var previews: some View {
        EditExpenseView(path: $path)
    }
}
