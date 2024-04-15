//
//  ExpenseItemView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 07/12/2023.
//

import SwiftUI

struct ExpenseItemView: View {
    
    let image: UIImage
    let expenseName: String
    let expenseAmount: Double
    
    var body: some View {
            HStack {
                Image(uiImage: image)
                    .padding(.leading)
                Text(expenseName)
                    .padding(.leading)
                Text(String(expenseAmount))
                Spacer()
            }
    }
}

#Preview {
    ExpenseItemView(image: UIImage(systemName: "plus")!, expenseName: "Food In London", expenseAmount: 20.00)
}
