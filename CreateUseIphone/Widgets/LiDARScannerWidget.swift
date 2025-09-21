import WidgetKit
import SwiftUI

struct LiDARScannerWidget: Widget {
    let kind: String = "LiDARScannerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScanProvider()) { entry in
            LiDARScannerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("LiDAR Scanner")
        .description("Quick access to room scanning and recent scan statistics")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ScanEntry: TimelineEntry {
    let date: Date
    let scanCount: Int
    let lastScanDate: Date?
    let totalRoomsScanned: Int
    let averageRoomSize: Double
    let recentScans: [RecentScan]
}

struct RecentScan: Codable {
    let id: UUID
    let roomName: String
    let area: Double
    let date: Date
    let featuresCount: Int
}

struct ScanProvider: TimelineProvider {
    func placeholder(in context: Context) -> ScanEntry {
        ScanEntry(
            date: Date(),
            scanCount: 5,
            lastScanDate: Date().addingTimeInterval(-3600),
            totalRoomsScanned: 12,
            averageRoomSize: 25.4,
            recentScans: [
                RecentScan(id: UUID(), roomName: "Living Room", area: 32.5, date: Date().addingTimeInterval(-3600), featuresCount: 8),
                RecentScan(id: UUID(), roomName: "Bedroom", area: 18.2, date: Date().addingTimeInterval(-7200), featuresCount: 5)
            ]
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ScanEntry) -> ()) {
        let entry = ScanEntry(
            date: Date(),
            scanCount: 3,
            lastScanDate: Date().addingTimeInterval(-1800),
            totalRoomsScanned: 8,
            averageRoomSize: 22.1,
            recentScans: [
                RecentScan(id: UUID(), roomName: "Kitchen", area: 15.8, date: Date().addingTimeInterval(-1800), featuresCount: 6)
            ]
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScanEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        let scanData = loadScanDataFromAppGroup()
        
        let entry = ScanEntry(
            date: currentDate,
            scanCount: scanData.count,
            lastScanDate: scanData.first?.date,
            totalRoomsScanned: scanData.count,
            averageRoomSize: scanData.isEmpty ? 0 : scanData.map(\.area).reduce(0, +) / Double(scanData.count),
            recentScans: Array(scanData.prefix(3))
        )
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
    
    private func loadScanDataFromAppGroup() -> [RecentScan] {
        guard let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourname.lidarscanner") else {
            return mockScanData()
        }
        
        let fileURL = sharedContainer.appendingPathComponent("widget_scan_data.json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([RecentScan].self, from: data)
        } catch {
            print("Error loading widget scan data: \(error)")
            return mockScanData()
        }
    }
    
    private func mockScanData() -> [RecentScan] {
        return [
            RecentScan(id: UUID(), roomName: "Living Room", area: 32.5, date: Date().addingTimeInterval(-3600), featuresCount: 8),
            RecentScan(id: UUID(), roomName: "Bedroom", area: 18.2, date: Date().addingTimeInterval(-7200), featuresCount: 5),
            RecentScan(id: UUID(), roomName: "Kitchen", area: 15.8, date: Date().addingTimeInterval(-10800), featuresCount: 6)
        ]
    }
}

struct LiDARScannerWidgetEntryView: View {
    var entry: ScanProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}