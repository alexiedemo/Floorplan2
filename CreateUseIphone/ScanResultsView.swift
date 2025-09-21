import SwiftUI
import SceneKit

struct ScanResultsView: View {
    @ObservedObject var scanManager: ScanManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 3D Preview Placeholder (SceneKit doesn't work well in previews)
                Group {
                    Text("3D Room Model")
                        .font(.headline)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 250)
                        .overlay(
                            VStack {
                                Image(systemName: "cube.transparent")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                Text("3D Model Preview")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Room Dimensions
                if let dimensions = scanManager.roomDimensions {
                    DimensionsCard(dimensions: dimensions)
                }
                
                // Detected Features
                if !scanManager.detectedFeatures.isEmpty {
                    FeaturesCard(features: scanManager.detectedFeatures)
                }
                
                // Scan Statistics
                ScanStatisticsCard(scanData: scanManager.currentScan)
                
                // Clear Scan Data Button
                Button("Clear Saved Scan Data") {
                    scanManager.clearStoredScans()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            .padding()
        }
    }
}

struct DimensionsCard: View {
    let dimensions: RoomDimensions
    @State private var useMetric = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Room Dimensions")
                    .font(.headline)
                
                Spacer()
                
                Button(useMetric ? "Metric" : "Imperial") {
                    useMetric.toggle()
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                DimensionItem(
                    title: "Width",
                    value: useMetric ? String(format: "%.2f m", dimensions.width) : String(format: "%.2f ft", dimensions.widthInFeet),
                    icon: "arrow.left.and.right"
                )
                
                DimensionItem(
                    title: "Length", 
                    value: useMetric ? String(format: "%.2f m", dimensions.length) : String(format: "%.2f ft", dimensions.lengthInFeet),
                    icon: "arrow.up.and.down"
                )
                
                DimensionItem(
                    title: "Height",
                    value: useMetric ? String(format: "%.2f m", dimensions.height) : String(format: "%.2f ft", dimensions.heightInFeet),
                    icon: "arrow.up.and.down.square"
                )
                
                DimensionItem(
                    title: "Area",
                    value: useMetric ? String(format: "%.2f m²", dimensions.area) : String(format: "%.2f ft²", dimensions.areaInSquareFeet),
                    icon: "square.grid.3x3"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DimensionItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct FeaturesCard: View {
    let features: [ArchitecturalFeature]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detected Features")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(ArchitecturalFeature.FeatureType.allCases, id: \.self) { featureType in
                    let count = features.filter { $0.type == featureType }.count
                    if count > 0 {
                        FeatureCountItem(type: featureType, count: count)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct FeatureCountItem: View {
    let type: ArchitecturalFeature.FeatureType
    let count: Int
    
    var body: some View {
        HStack {
            Image(systemName: iconForFeatureType(type))
                .foregroundColor(.blue)
            
            Text(type.rawValue.capitalized)
                .font(.caption)
            
            Spacer()
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private func iconForFeatureType(_ type: ArchitecturalFeature.FeatureType) -> String {
        switch type {
        case .door: return "door.left.hand.open"
        case .window: return "rectangle.inset.filled"
        case .opening: return "rectangle.portrait"
        case .wall: return "rectangle.fill"
        case .corner: return "arrow.turn.up.right"
        case .ceiling: return "rectangle.topthird.inset.filled"
        case .floor: return "rectangle.bottomthird.inset.filled"
        }
    }
}

struct ScanStatisticsCard: View {
    let scanData: ScanData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Scan Statistics")
                .font(.headline)
            
            if let scanData = scanData {
                VStack(spacing: 10) {
                    StatRow(title: "Point Cloud Size", value: "\(scanData.pointCloud.count) points")
                    StatRow(title: "Mesh Anchors", value: "\(scanData.meshAnchors.count)")
                    StatRow(title: "Features Detected", value: "\(scanData.features.count)")
                    StatRow(title: "Scan Date", value: DateFormatter.localizedString(from: scanData.timestamp, dateStyle: .short, timeStyle: .short))
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}