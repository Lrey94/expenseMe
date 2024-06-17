//
//  NavigationDestination.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 12/06/2024.
//

import Foundation

enum NavigationDestination: Hashable {
    case editExpense(expense: Expense)
    case addExpense
}
