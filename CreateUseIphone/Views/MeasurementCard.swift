import SwiftUI

struct MeasurementCard: View {
    let title: String
    let measurements: [Measurement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(measurements, id: \.label) { measurement in
                    MeasurementItem(measurement: measurement)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MeasurementItem: View {
    let measurement: Measurement
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: measurement.icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(measurement.label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(measurement.value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct Measurement {
    let label: String
    let value: String
    let icon: String
}

#Preview {
    MeasurementCard(
        title: "Room Measurements",
        measurements: [
            Measurement(label: "Width", value: "4.2 m", icon: "arrow.left.and.right"),
            Measurement(label: "Length", value: "5.8 m", icon: "arrow.up.and.down"),
            Measurement(label: "Height", value: "2.7 m", icon: "arrow.up.and.down.square"),
            Measurement(label: "Area", value: "24.4 m²", icon: "square.grid.3x3")
        ]
    )
}