import SwiftUI

@main
struct CreateUseIphoneApp: App {
    @StateObject private var store = ScanStore()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
