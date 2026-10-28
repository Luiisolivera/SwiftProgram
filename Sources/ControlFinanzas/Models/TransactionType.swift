import Foundation

public enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case income = "Ingreso"
    case expense = "Gasto"
    
    public var id: String { rawValue }
}
