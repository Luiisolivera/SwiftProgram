import SwiftUI
import SwiftData

public struct ControlFinanzasApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(for: Transaction.self)
    }
}
