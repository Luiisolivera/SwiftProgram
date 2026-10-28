import XCTest
import SwiftData
@testable import ControlFinanzas

final class FinanceServiceTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var service: FinanceService!
    
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Transaction.self, configurations: config)
        context = ModelContext(container)
        service = FinanceService(modelContext: context)
    }
    
    override func tearDownWithError() throws {
        container = nil
        context = nil
        service = nil
    }
    
    func testAddIncomeIncreasesIncomeAndBalance() throws {
        try service.addTransaction(
            title: "Sueldo Mensual",
            amount: 2500,
            type: .income,
            category: .salario
        )
        
        let all = try service.fetchAllTransactions()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.title, "Sueldo Mensual")
        XCTAssertEqual(all.first?.category, .salario)
        XCTAssertEqual(service.calculateTotalIncome(from: all), 2500)
        XCTAssertEqual(service.calculateTotalExpenses(from: all), 0)
        XCTAssertEqual(service.calculateBalance(from: all), 2500)
    }
    
    func testAddExpenseDecreasesBalance() throws {
        try service.addTransaction(
            title: "Sueldo",
            amount: 1000,
            type: .income,
            category: .salario
        )
        try service.addTransaction(
            title: "Supermercado",
            amount: 300,
            type: .expense,
            category: .alimentacion
        )
        
        let all = try service.fetchAllTransactions()
        XCTAssertEqual(all.count, 2)
        XCTAssertEqual(service.calculateTotalIncome(from: all), 1000)
        XCTAssertEqual(service.calculateTotalExpenses(from: all), 300)
        XCTAssertEqual(service.calculateBalance(from: all), 700)
    }
    
    func testInvalidAmountThrowsError() {
        XCTAssertThrowsError(
            try service.addTransaction(
                title: "Invalido Cero",
                amount: 0,
                type: .expense,
                category: .otros
            )
        ) { error in
            XCTAssertEqual(error as? FinanceError, .invalidAmount)
        }
        
        XCTAssertThrowsError(
            try service.addTransaction(
                title: "Invalido Negativo",
                amount: -50,
                type: .expense,
                category: .otros
            )
        ) { error in
            XCTAssertEqual(error as? FinanceError, .invalidAmount)
        }
    }
    
    func testEmptyTitleThrowsError() {
        XCTAssertThrowsError(
            try service.addTransaction(
                title: "    ",
                amount: 50,
                type: .expense,
                category: .otros
            )
        ) { error in
            XCTAssertEqual(error as? FinanceError, .invalidTitle)
        }
    }
    
    func testDeleteTransactionRemovesItAndRecalculates() throws {
        let tx = try service.addTransaction(
            title: "Factura de Luz",
            amount: 120,
            type: .expense,
            category: .vivienda
        )
        
        var all = try service.fetchAllTransactions()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(service.calculateBalance(from: all), -120)
        
        try service.deleteTransaction(tx)
        
        all = try service.fetchAllTransactions()
        XCTAssertEqual(all.count, 0)
        XCTAssertEqual(service.calculateBalance(from: all), 0)
    }
}
