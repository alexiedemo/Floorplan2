#if canImport(RoomPlan) && !targetEnvironment(simulator)
import SwiftUI
import RoomPlan
import RealityKit

@available(iOS 16.0, *)
struct RoomPlanScannerView: View {
    @State private var capturedPlan: CapturedRoom?
    var body: some View {
        VStack {
            if capturedPlan != nil {
                Text("Scan Complete")
            } else {
                RoomCaptureViewRepresentable(capturedRoom: $capturedPlan).ignoresSafeArea()
            }
        }
        .navigationTitle("Room Scan")
    }
}

@available(iOS 16.0, *)
struct RoomCaptureViewRepresentable: UIViewControllerRepresentable {
    @Binding var capturedRoom: CapturedRoom?
    func makeUIViewController(context: Context) -> RoomCaptureViewController {
        let rc = RoomCaptureViewController()
        rc.captureOptions = [.captureScene, .captureRoom]
        rc.delegate = context.coordinator
        return rc
    }
    func updateUIViewController(_ uiViewController: RoomCaptureViewController, context: Context) {}
    func makeCoordinator() -> Coord { Coord(parent: self) }
    class Coord: NSObject, RoomCaptureViewControllerDelegate {
        let parent: RoomCaptureViewRepresentable
        init(parent: RoomCaptureViewRepresentable) { self.parent = parent }
        func captureViewController(_ viewController: RoomCaptureViewController, didPresent processedResult: CapturedRoom, error: (any Error)?) {
            if error == nil { parent.capturedRoom = processedResult }
        }
    }
}
#else
import SwiftUI
struct RoomPlanScannerView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "arkit").font(.system(size: 56))
            Text("RoomPlan not available").font(.headline)
            Text("Run on a LiDAR device or use the editor.").foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Room Scan")
    }
}
#endif
