import SwiftUI
import ARKit
import RealityKit
import SceneKit

struct ContentView: View {
    @StateObject private var scanManager = ScanManager()
    @State private var showingExportOptions = false
    @State private var showingFloorPlan = false
    @State private var showingInstructions = false
    @State private var showingError: ScanError?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack {
                    if let error = showingError {
                        ErrorView(error: error) {
                            handleRetry(for: error)
                        }
                    } else if scanManager.isScanning {
                        ZStack {
                            ARScanView(scanManager: scanManager)
                            
                            VStack {
                                Spacer()
                                ScanningProgressView(scanManager: scanManager)
                                    .padding()
                            }
                        }
                    } else if scanManager.hasCompletedScan {
                        ScanResultsView(scanManager: scanManager)
                    } else {
                        WelcomeView(scanManager: scanManager)
                    }
                }
                
                // Instructions overlay
                if showingInstructions {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showingInstructions = false
                        }
                    
                    ScanningInstructionsView(showInstructions: $showingInstructions)
                        .padding()
                }
            }
            .navigationTitle("LiDAR Room Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if scanManager.isScanning {
                        Button("Help") {
                            showingInstructions = true
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if scanManager.hasCompletedScan {
                        Button("Floor Plan") {
                            showingFloorPlan = true
                        }
                        
                        Button("Export") {
                            showingExportOptions = true
                        }
                    }
                }
            }
        }
        .onAppear {
            checkLiDARSupport()
        }
        .sheet(isPresented: $showingFloorPlan) {
            FloorPlanView(scanData: scanManager.currentScan)
        }
        .sheet(isPresented: $showingExportOptions) {
            ExportOptionsView(scanData: scanManager.currentScan)
        }
    }
    
    private func checkLiDARSupport() {
        if !ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            showingError = .lidarNotSupported
        }
    }
    
    private func handleRetry(for error: ScanError) {
        showingError = nil
        
        switch error {
        case .scanFailed, .noData:
            scanManager.startScanning()
        default:
            break
        }
    }
}