import SwiftUI
import SwiftData

public struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory = .alimentacion
    @State private var date: Date = Date()
    @State private var notes: String = ""
    
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Movimiento") {
                    Picker("Tipo", selection: $selectedType) {
                        ForEach(TransactionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Detalles") {
                    TextField("Concepto (ej. Supermercado)", text: $title)
                    
                    TextField("Monto (ej. 150.00)", text: $amountText)
                        .keyboardType(.decimalPad)
                    
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(TransactionCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.iconName)
                                .tag(category)
                        }
                    }
                    
                    DatePicker("Fecha", selection: $date, displayedComponents: .date)
                }
                
                Section("Notas (Opcional)") {
                    TextField("Detalles adicionales...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Nueva Transacción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { saveTransaction() }
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("Entendido", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Datos no válidos")
            }
        }
    }
    
    private func saveTransaction() {
        let cleanAmountText = amountText.replacingOccurrences(of: ",", with: ".")
        guard let decimalAmount = Decimal(string: cleanAmountText) else {
            errorMessage = "Ingresa un monto numérico válido."
            showErrorAlert = true
            return
        }
        
        let service = FinanceService(modelContext: modelContext)
        do {
            try service.addTransaction(
                title: title,
                amount: decimalAmount,
                type: selectedType,
                category: selectedCategory,
                date: date,
                notes: notes.isEmpty ? nil : notes
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
