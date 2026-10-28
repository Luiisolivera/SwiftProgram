import SwiftUI
import SwiftData

@main
public struct ControlFinanzasApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(for: Transaction.self)
    }
}
