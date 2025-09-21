import SwiftUI

/// A wrapper that picks RoomPlan when available, otherwise shows guidance.
struct ScannerGatewayView: View {
    var body: some View {
        #if canImport(RoomPlan)
        if #available(iOS 17.0, *) {
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
            Image(systemName: "arkit")
                .font(.system(size: 56))
            Text("RoomPlan not available on this device")
                .font(.title3).bold()
            Text("You can still open the Editor with a sample plan, or run on a LiDAR-capable iPhone to scan rooms.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Scanner")
    }
}
