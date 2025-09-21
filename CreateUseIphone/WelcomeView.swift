import SwiftUI

struct WelcomeView: View {
    @ObservedObject var scanManager: ScanManager
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lidar")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                Text("LiDAR Room Scanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Create accurate 3D room scans and floor plans using your iPhone's LiDAR sensor")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                FeatureRow(icon: "camera.fill", title: "3D Room Scanning", description: "Capture detailed room geometry")
                FeatureRow(icon: "square.and.pencil", title: "Floor Plans", description: "Generate accurate floor plans with measurements")
                FeatureRow(icon: "door.left.hand.open", title: "Feature Detection", description: "Automatically identify doors, windows, and openings")
                FeatureRow(icon: "square.and.arrow.up", title: "Export Options", description: "Export in multiple formats (USD, OBJ, PDF, etc.)")
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                scanManager.startScanning()
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Scanning")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}