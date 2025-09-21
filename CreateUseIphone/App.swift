import SwiftUI

@main
struct CreateUseIphoneApp: App {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @StateObject private var store = ScanStore()
    @StateObject private var settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            Group {
                if hasOnboarded {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(store)
            .environmentObject(settings)
        }
    }
}
