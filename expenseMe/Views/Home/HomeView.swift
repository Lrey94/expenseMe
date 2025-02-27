import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HeaderView
                ListView
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .editExpense(let expense):
                    ExpenseDetailView(path: $path, expense: expense)
                case .addExpense:
                    AddExpenseView(path: $path)
                }
            }
            .toolbar {
                Button {
                    path.append(NavigationDestination.addExpense)
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                homeViewModel.fetchExpenses()
            }
        }
    }
    
    var HeaderView: some View {
        VStack {
            HStack {
                Text("Expense Me")
                    .font(.title)
                    .fontWeight(.medium)
                    .shadow(radius: 2)
                    .padding(.leading, 10)
                Spacer()
            }
            if !homeViewModel.expenses.isEmpty {
                HStack {
                    Text("Total to be claimed: \(homeViewModel.runningExpenseTotal >= 0.0 ? "£" : "")\(homeViewModel.runningExpenseTotal >= 0.0 ? String(format: "%.2f", homeViewModel.runningExpenseTotal) : "Unavailable")")
                        .font(.title2)
                        .fontWeight(.medium)
                        .shadow(radius: 2)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.top)
            }
        }
        .onAppear {
            homeViewModel.fetchExpenses()
        }
    }
    
    var ListView: some View {
        VStack {
            if homeViewModel.expenses.isEmpty {
                ContentUnavailableView("No expense items", systemImage: "exclamationmark.triangle.fill")
            } else {
                ScrollView {
                    ForEach(homeViewModel.expenses, id: \.expenseID) { expense in
                        if let image = expense.image {
                            NavigationLink(value: NavigationDestination.editExpense(expense: expense)) {
                                ListItemView(expenseImage: image,
                                             expenseName: expense.expenseName,
                                             expenseAmount: expense.expenseAmount)
                            }
                            .isDetailLink(false)
                            .padding()
                        }
                    }
                }
            }
        }
    }
}


struct ListItemView: View {
    
    let expenseImage: Data
    let expenseName: String
    let expenseAmount: Double
    
    var body: some View {
        VStack {
            HStack {
                if let expenseImage = UIImage(data: expenseImage) {
                    Image(uiImage: expenseImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(expenseName)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("£\(String(format: "%.2f", expenseAmount))")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .padding(.leading)
                Spacer()
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 140)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
        .padding(.horizontal, 5)
    }
}

#Preview {
    HomeView()
}
