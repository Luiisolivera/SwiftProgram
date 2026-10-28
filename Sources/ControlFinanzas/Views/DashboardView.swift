import SwiftUI
import SwiftData

public struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    @State private var showingAddSheet: Bool = false
    @State private var filterType: TransactionType? = nil
    
    public init() {}
    
    private var filteredTransactions: [Transaction] {
        guard let filterType else { return transactions }
        return transactions.filter { $0.type == filterType }
    }
    
    private var service: FinanceService {
        FinanceService(modelContext: modelContext)
    }
    
    private var totalIncome: Decimal {
        service.calculateTotalIncome(from: transactions)
    }
    
    private var totalExpenses: Decimal {
        service.calculateTotalExpenses(from: transactions)
    }
    
    private var balance: Decimal {
        service.calculateBalance(from: transactions)
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section {
                    balanceSummaryCard
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                Section {
                    filterPicker
                }
                .listRowBackground(Color.clear)
                
                Section {
                    if filteredTransactions.isEmpty {
                        ContentUnavailableView(
                            "Sin transacciones",
                            systemImage: "tray.fill",
                            description: Text("Toca el botón + para registrar tu primer ingreso o gasto.")
                        )
                    } else {
                        ForEach(filteredTransactions) { item in
                            TransactionRowView(transaction: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                } header: {
                    Text("Movimientos (\(filteredTransactions.count))")
                }
            }
            .navigationTitle("Control de Finanzas")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTransactionView()
            }
        }
    }
    
    private var balanceSummaryCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Balance Total")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                
                Text(formatCurrency(balance))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 12) {
                summarySubcard(
                    title: "Ingresos",
                    amount: totalIncome,
                    systemImage: "arrow.down.circle.fill",
                    color: Color.green.opacity(0.25)
                )
                
                summarySubcard(
                    title: "Gastos",
                    amount: totalExpenses,
                    systemImage: "arrow.up.circle.fill",
                    color: Color.red.opacity(0.25)
                )
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func summarySubcard(
        title: String,
        amount: Decimal,
        systemImage: String,
        color: Color
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text(formatCurrency(amount))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(10)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var filterPicker: some View {
        Picker("Filtro", selection: $filterType) {
            Text("Todos").tag(TransactionType?.none)
            Text("Ingresos").tag(TransactionType?.some(.income))
            Text("Gastos").tag(TransactionType?.some(.expense))
        }
        .pickerStyle(.segmented)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = filteredTransactions[index]
            try? service.deleteTransaction(item)
        }
    }
    
    private func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        let num = NSDecimalNumber(decimal: value)
        return formatter.string(from: num) ?? "\(value)"
    }
}
