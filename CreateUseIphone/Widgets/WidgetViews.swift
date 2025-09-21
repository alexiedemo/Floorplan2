import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: ScanEntry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "lidar")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("\(entry.scanCount)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Room Scans")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let lastScan = entry.lastScanDate {
                    Text("Last: \(lastScan, style: .relative) ago")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                } else {
                    Text("No recent scans")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Link(destination: URL(string: "lidarscanner://newscan")!) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.caption)
                    Text("Scan")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct MediumWidgetView: View {
    let entry: ScanEntry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lidar")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("LiDAR Scanner")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    StatRow(label: "Total Scans", value: "\(entry.scanCount)")
                    StatRow(label: "Rooms", value: "\(entry.totalRoomsScanned)")
                    StatRow(label: "Avg Size", value: String(format: "%.1f m²", entry.averageRoomSize))
                }
                
                Spacer()
                
                Link(destination: URL(string: "lidarscanner://newscan")!) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Scan")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Recent Scans")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                if entry.recentScans.isEmpty {
                    VStack {
                        Image(systemName: "house.circle")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("No scans yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(entry.recentScans.prefix(2), id: \.id) { scan in
                            RecentScanRow(scan: scan)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

struct LargeWidgetView: View {
    let entry: ScanEntry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lidar")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text("LiDAR Room Scanner")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    if let lastScan = entry.lastScanDate {
                        Text("Last scan: \(lastScan, style: .relative) ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Link(destination: URL(string: "lidarscanner://newscan")!) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Scan")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                StatCard(title: "Total Scans", value: "\(entry.scanCount)", icon: "doc.text.fill", color: .blue)
                StatCard(title: "Rooms", value: "\(entry.totalRoomsScanned)", icon: "house.fill", color: .green)
                StatCard(title: "Avg Size", value: String(format: "%.1f m²", entry.averageRoomSize), icon: "ruler.fill", color: .orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Recent Scans")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Link(destination: URL(string: "lidarscanner://allscans")!) {
                        Text("View All")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if entry.recentScans.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "house.circle")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("No scans yet")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                } else {
                    VStack(spacing: 6) {
                        ForEach(entry.recentScans.prefix(3), id: \.id) { scan in
                            DetailedScanRow(scan: scan)
                        }
                    }
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}