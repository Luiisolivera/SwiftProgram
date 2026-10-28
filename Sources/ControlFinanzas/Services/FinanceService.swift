import Foundation
import SwiftData

public enum FinanceError: LocalizedError, Equatable {
    case invalidTitle
    case invalidAmount
    
    public var errorDescription: String? {
        switch self {
        case .invalidTitle:
            return "El título no puede estar vacío."
        case .invalidAmount:
            return "El monto debe ser mayor que cero."
        }
    }
}

public final class FinanceService {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @discardableResult
    public func addTransaction(
        title: String,
        amount: Decimal,
        type: TransactionType,
        category: TransactionCategory,
        date: Date = Date(),
        notes: String? = nil
    ) throws -> Transaction {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            throw FinanceError.invalidTitle
        }
        guard amount > 0 else {
            throw FinanceError.invalidAmount
        }
        
        let transaction = Transaction(
            title: trimmedTitle,
            amount: amount,
            type: type,
            category: category,
            date: date,
            notes: notes
        )
        
        modelContext.insert(transaction)
        try modelContext.save()
        return transaction
    }
    
    public func deleteTransaction(_ transaction: Transaction) throws {
        modelContext.delete(transaction)
        try modelContext.save()
    }
    
    public func fetchAllTransactions() throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func calculateTotalIncome(from transactions: [Transaction]) -> Decimal {
        transactions
            .filter { $0.type == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }
    
    public func calculateTotalExpenses(from transactions: [Transaction]) -> Decimal {
        transactions
            .filter { $0.type == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }
    
    public func calculateBalance(from transactions: [Transaction]) -> Decimal {
        let income = calculateTotalIncome(from: transactions)
        let expenses = calculateTotalExpenses(from: transactions)
        return income - expenses
    }
}
