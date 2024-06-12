//
//  NavigationDestination.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 15/04/2024.
//

import Foundation

enum NavigationDestination: Hashable {
    case editExpense(Expense)
    case addExpense
}
