import SwiftUI

public struct TransactionRowView: View {
    public let transaction: Transaction
    
    public init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            Image(systemName: transaction.category.iconName)
                .font(.title3)
                .foregroundColor(transaction.type == .income ? .green : .red)
                .frame(width: 40, height: 40)
                .background(
                    (transaction.type == .income ? Color.green : Color.red)
                        .opacity(0.12)
                )
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                
                HStack {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(formattedAmount)
                .font(.headline)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
    
    private var formattedAmount: String {
        let prefix = transaction.type == .income ? "+" : "-"
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        let amountNumber = NSDecimalNumber(decimal: transaction.amount)
        let amountText = formatter.string(from: amountNumber) ?? "\(transaction.amount)"
        return "\(prefix)\(amountText)"
    }
}
