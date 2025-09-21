import SwiftUI

struct FeatureListView: View {
    let features: [ArchitecturalFeature]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detected Features")
                .font(.headline)
            
            if features.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("No features detected yet")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(features) { feature in
                        FeatureRow(feature: feature)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct FeatureRow: View {
    let feature: ArchitecturalFeature
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForFeatureType(feature.type))
                .font(.title3)
                .foregroundColor(colorForFeatureType(feature.type))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.type.rawValue.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(dimensionString(feature.dimensions))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(feature.confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(confidenceColor(feature.confidence))
                
                Text("confidence")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
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
    
    private func colorForFeatureType(_ type: ArchitecturalFeature.FeatureType) -> Color {
        switch type {
        case .door: return .blue
        case .window: return .green
        case .opening: return .orange
        case .wall: return .gray
        case .corner: return .purple
        case .ceiling: return .brown
        case .floor: return .red
        }
    }
    
    private func dimensionString(_ dimensions: SIMD3<Float>) -> String {
        return String(format: "%.1f × %.1f × %.1f m", dimensions.x, dimensions.y, dimensions.z)
    }
    
    private func confidenceColor(_ confidence: Float) -> Color {
        if confidence > 0.8 { return .green }
        if confidence > 0.6 { return .orange }
        return .red
    }
}

#Preview {
    FeatureListView(features: ScanManager.mockScanManager().detectedFeatures)
}