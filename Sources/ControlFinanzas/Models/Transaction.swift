import Foundation
import SwiftData

@Model
public final class Transaction {
    public var id: UUID
    public var title: String
    public var amount: Decimal
    public var date: Date
    public var typeRaw: String
    public var categoryRaw: String
    public var notes: String?
    
    public var type: TransactionType {
        get { TransactionType(rawValue: typeRaw) ?? .expense }
        set { typeRaw = newValue.rawValue }
    }
    
    public var category: TransactionCategory {
        get { TransactionCategory(rawValue: categoryRaw) ?? .otros }
        set { categoryRaw = newValue.rawValue }
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        amount: Decimal,
        type: TransactionType,
        category: TransactionCategory,
        date: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.typeRaw = type.rawValue
        self.categoryRaw = category.rawValue
        self.date = date
        self.notes = notes
    }
}
