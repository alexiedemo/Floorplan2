import SwiftUI
#if canImport(RoomPlan)
import RoomPlan
import RealityKit

@available(iOS 17.0, *)
struct RoomPlanScannerView: View {
    @State private var capturedPlan: CapturedRoom?
    @EnvironmentObject var store: ScanStore
    
    var body: some View {
        VStack {
            if let plan = capturedPlan {
                VStack(spacing: 12) {
                    Text("Scan Complete").font(.title3).bold()
                    HStack {
                        Button("Save & Open Editor") {
                            let converter = FloorPlanConverter()
                            let fp = converter.convert(from: plan)
                            store.save(plan: fp)
                        }
                        .brandedButtonProminent()
                        Button("Discard") { capturedPlan = nil }.buttonStyle(.bordered)
                    }
                }.padding()
            } else {
                RoomCaptureViewRepresentable(capturedRoom: $capturedPlan)
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Room Scan")
    }
}

@available(iOS 17.0, *)
struct RoomCaptureViewRepresentable: UIViewControllerRepresentable {
    @Binding var capturedRoom: CapturedRoom?
    func makeUIViewController(context: Context) -> RoomCaptureViewController {
        let rc = RoomCaptureViewController()
        rc.delegate = context.coordinator
        rc.captureOptions = [.captureScene, .captureRoom]
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
#endif
