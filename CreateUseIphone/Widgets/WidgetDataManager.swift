import Foundation
import WidgetKit

class WidgetDataManager {
    static let shared = WidgetDataManager()
    private let appGroupIdentifier = "group.com.yourname.lidarscanner"
    
    private init() {}
    
    func updateWidgetData(with scans: [ScanData]) {
        let recentScans = scans.prefix(5).map { scan in
            RecentScan(
                id: scan.id,
                roomName: extractRoomName(from: scan),
                area: Double(scan.dimensions?.area ?? 0),
                date: scan.timestamp,
                featuresCount: scan.features.count
            )
        }
        
        saveWidgetData(recentScans)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func saveWidgetData(_ scans: [RecentScan]) {
        guard let sharedContainer = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            print("Unable to access shared container")
            return
        }
        
        let fileURL = sharedContainer.appendingPathComponent("widget_scan_data.json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(scans)
            try data.write(to: fileURL)
        } catch {
            print("Error saving widget data: \(error)")
        }
    }
    
    private func extractRoomName(from scan: ScanData) -> String {
        if let floorPlan = scan.floorPlan,
           let firstRoom = floorPlan.rooms.first {
            return firstRoom.name
        }
        
        if let dimensions = scan.dimensions {
            if dimensions.area < 15 {
                return "Small Room"
            } else if dimensions.area < 30 {
                return "Medium Room"
            } else {
                return "Large Room"
            }
        }
        
        return "Room \(scan.timestamp.formatted(.dateTime.hour().minute()))"
    }
}

extension ScanManager {
    func updateWidgetData() {
        WidgetDataManager.shared.updateWidgetData(with: storedScans)
    }
}