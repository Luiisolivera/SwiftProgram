import Foundation

public enum TransactionCategory: String, Codable, CaseIterable, Identifiable {
    case salario = "Salario"
    case alimentacion = "Alimentación"
    case transporte = "Transporte"
    case vivienda = "Vivienda"
    case entretenimiento = "Entretenimiento"
    case salud = "Salud"
    case educacion = "Educación"
    case otros = "Otros"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .salario: return "dollarsign.circle.fill"
        case .alimentacion: return "fork.knife"
        case .transporte: return "car.fill"
        case .vivienda: return "house.fill"
        case .entretenimiento: return "gamecontroller.fill"
        case .salud: return "heart.fill"
        case .educacion: return "book.fill"
        case .otros: return "square.grid.2x2.fill"
        }
    }
}
