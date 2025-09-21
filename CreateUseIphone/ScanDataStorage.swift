import Foundation

class ScanDataStorage {
    
    static let shared = ScanDataStorage()
    
    private init() {}
    
    private let fileManager = FileManager.default
    private lazy var documentsDirectory: URL? = {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    private let scanDataFilename = "scan_data.json"
    
    func saveScanData(_ scanData: [ScanData]) {
        guard let documentsDirectory = documentsDirectory else {
            print("Could not access documents directory")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(scanDataFilename)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scanData)
            try data.write(to: fileURL)
            print("Scan data saved to: \(fileURL)")
        } catch {
            print("Error saving scan data: \(error)")
        }
    }
    
    func loadScanData() -> [ScanData]? {
        guard let documentsDirectory = documentsDirectory else {
            print("Could not access documents directory")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(scanDataFilename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let scanData = try decoder.decode([ScanData].self, from: data)
            print("Scan data loaded from: \(fileURL)")
            return scanData
        } catch {
            print("Error loading scan data: \(error)")
            return nil
        }
    }
    
    func clearScanData() {
        guard let documentsDirectory = documentsDirectory else {
            print("Could not access documents directory")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(scanDataFilename)
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("Scan data cleared from: \(fileURL)")
        } catch {
            print("Error clearing scan data: \(error)")
        }
    }
}