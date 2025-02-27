import SwiftUI
import SwiftData

@main
struct expenseMeApp: App {

    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var addExpenseViewModel: AddExpenseViewModel
    @StateObject private var swiftDataManager: SwiftDataManager

    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Expense.self)
            let modelContext = modelContainer.mainContext
            let locationManager = LocationManager()
            let swiftDataManager = SwiftDataManager(modelContext: modelContext)
            _swiftDataManager = StateObject(wrappedValue: swiftDataManager)
            _addExpenseViewModel = StateObject(wrappedValue: AddExpenseViewModel(swiftDataManager: swiftDataManager, locationManager: locationManager))
            _homeViewModel = StateObject(wrappedValue: HomeViewModel(swiftDataManager: swiftDataManager))
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

