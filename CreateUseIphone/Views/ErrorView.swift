import SwiftUI

struct ErrorView: View {
    let error: ScanError
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: error.icon)
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                Text(error.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(error.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            if error.isRetryable {
                Button("Try Again") {
                    retry()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
    }
}

enum ScanError {
    case lidarNotSupported
    case cameraPermissionDenied
    case scanFailed
    case noData
    
    var title: String {
        switch self {
        case .lidarNotSupported:
            return "LiDAR Not Available"
        case .cameraPermissionDenied:
            return "Camera Permission Required"
        case .scanFailed:
            return "Scan Failed"
        case .noData:
            return "No Scan Data"
        }
    }
    
    var message: String {
        switch self {
        case .lidarNotSupported:
            return "This device doesn't support LiDAR scanning. You need an iPhone 12 Pro or newer."
        case .cameraPermissionDenied:
            return "Camera access is required for room scanning. Please enable it in Settings."
        case .scanFailed:
            return "The scanning process encountered an error. Please try again."
        case .noData:
            return "No scan data is available to display."
        }
    }
    
    var icon: String {
        switch self {
        case .lidarNotSupported:
            return "exclamationmark.triangle.fill"
        case .cameraPermissionDenied:
            return "camera.fill"
        case .scanFailed:
            return "xmark.circle.fill"
        case .noData:
            return "doc.questionmark.fill"
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .lidarNotSupported, .cameraPermissionDenied:
            return false
        case .scanFailed, .noData:
            return true
        }
    }
}

#Preview {
    ErrorView(error: .lidarNotSupported) {
        print("Retry tapped")
    }
}