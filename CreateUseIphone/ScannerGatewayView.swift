import SwiftUI

struct ScannerGatewayView: View {
    var body: some View {
        #if canImport(RoomPlan) && !targetEnvironment(simulator)
        if #available(iOS 16.0, *) {
            RoomPlanScannerView()
        } else {
            NoRoomPlanView()
        }
        #else
        NoRoomPlanView()
        #endif
    }
}

struct NoRoomPlanView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "arkit").font(.system(size: 56))
            Text("RoomPlan not available on this device").font(.headline)
            Text("Run on a LiDAR‑capable iPhone or use the editor.").foregroundStyle(.secondary)
        }.padding().navigationTitle("Scanner")
    }
}
