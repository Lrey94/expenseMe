import Foundation
import SwiftData
import XCTest

@testable import expenseMe

class SwiftDataManagerTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var swiftDataManager: SwiftDataManager!
    
    @MainActor override func setUp() {
        super.setUp()
        do {
            modelContainer = try ModelContainer(for: Expense.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            modelContext = modelContainer.mainContext
            swiftDataManager = SwiftDataManager(modelContext: modelContext)
        } catch {
            XCTFail("Failed to create in-memory ModelContainer: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        modelContainer = nil
        modelContext = nil
        swiftDataManager = nil
        super.tearDown()
    }
    
    func testInsertExpense() {
        let expense = Expense(expenseName: "Test Expense", expenseAmount: 100.00, image: Data(), expenseImageDate: Date(), geolocationMetadata: GeoLocation())
        
        let expectation = self.expectation(description: "Insert expense completion")
        
        // Act
        swiftDataManager.insertExpense(expense: expense) { success in
            XCTAssertTrue(success, "Expense should be inserted successfully")
            
            let fetchedExpenses = self.swiftDataManager.fetchExpenses()
            XCTAssertEqual(fetchedExpenses?.count, 1, "There should be one expense in the database")
            XCTAssertEqual(fetchedExpenses?.first?.expenseName, "Test Expense")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchExpensesFailure() {
        let fetchedExpenses = swiftDataManager.fetchExpenses()
        XCTAssertNotNil(fetchedExpenses, "Fetch should not return nil")
        XCTAssertTrue(fetchedExpenses!.isEmpty, "Fetch should return an empty array when no expenses exist")
    }
    
    func testDeleteExpense() {
        //Arrange
        let expense = Expense(expenseName: "Test Expense", expenseAmount: 100.00, image: Data(), expenseImageDate: Date(), geolocationMetadata: GeoLocation())
        
        // Act
        swiftDataManager.insertExpense(expense: expense) { success in
            XCTAssertTrue(success, "Expense should be inserted successfully")
        }
        
        XCTAssertEqual(swiftDataManager.fetchExpenses()?.count, 1, "Database should contain one expense")
        swiftDataManager.deleteExpense(expense: expense)
        
        // Assert
        XCTAssertEqual(swiftDataManager.fetchExpenses()?.count, 0, "Database should be empty after deleting the expense")
    }
}
