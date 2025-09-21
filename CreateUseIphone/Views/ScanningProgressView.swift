import SwiftUI

struct ScanningProgressView: View {
    @ObservedObject var scanManager: ScanManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(scanManager.scanProgress))
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: scanManager.scanProgress)
                
                Text("\(Int(scanManager.scanProgress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 12) {
                Text("Scanning Room...")
                    .font(.headline)
                
                Text("Move your device slowly around the room")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "cube.transparent")
                        .foregroundColor(.blue)
                    Text("Mesh Anchors: \(scanManager.meshAnchors.count)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .foregroundColor(.green)
                    Text("Features: \(scanManager.detectedFeatures.count)")
                        .font(.caption)
                }
            }
            
            Button("Stop Scanning") {
                scanManager.stopScanning()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    ScanningProgressView(scanManager: ScanManager.mockScanManager())
}