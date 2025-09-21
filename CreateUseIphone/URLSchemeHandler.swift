import SwiftUI

class URLSchemeHandler: ObservableObject {
    @Published var shouldStartScan = false
    @Published var shouldShowAllScans = false
    
    func handleURL(_ url: URL) {
        guard url.scheme == "lidarscanner" else { return }
        
        switch url.host {
        case "newscan":
            shouldStartScan = true
        case "allscans":
            shouldShowAllScans = true
        default:
            break
        }
    }
}

// Add this to your App.swift file
struct LiDARRoomScannerApp: App {
    @StateObject private var urlHandler = URLSchemeHandler()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(urlHandler)
                .onOpenURL { url in
                    urlHandler.handleURL(url)
                }
        }
    }
}

// Update your ContentView to handle URL schemes
extension ContentView {
    var body: some View {
        NavigationView {
            // ... existing content ...
        }
        .onReceive(urlHandler.$shouldStartScan) { shouldStart in
            if shouldStart {
                scanManager.startScanning()
                urlHandler.shouldStartScan = false
            }
        }
        .onReceive(urlHandler.$shouldShowAllScans) { shouldShow in
            if shouldShow {
                // Navigate to all scans view
                urlHandler.shouldShowAllScans = false
            }
        }
    }
}