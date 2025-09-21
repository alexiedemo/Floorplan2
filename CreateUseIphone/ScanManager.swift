import Foundation
import ARKit
import RealityKit
import Combine

@MainActor
class ScanManager: NSObject, ObservableObject {
    @Published var isScanning = false
    @Published var hasCompletedScan = false
    @Published var currentScan: ScanData?
    @Published var scanProgress: Float = 0.0
    @Published var detectedFeatures: [ArchitecturalFeature] = []
    @Published var roomDimensions: RoomDimensions?
    
    private var arView: ARView?
    var meshAnchors: [ARMeshAnchor] = [] // Made public for access
    private var pointCloud: [SIMD3<Float>] = []
    private let featureDetector = FeatureDetector()
    private let floorPlanGenerator = FloorPlanGenerator()
    
    // Stored scan data
    @Published var storedScans: [ScanData] = []
    
    override init() {
        super.init()
        loadStoredScans()
    }
    
    func startScanning() {
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            print("LiDAR not supported on this device")
            return
        }
        
        isScanning = true
        hasCompletedScan = false
        meshAnchors.removeAll()
        pointCloud.removeAll()
        detectedFeatures.removeAll()
        scanProgress = 0.0
    }
    
    func stopScanning() {
        isScanning = false
        processScanData()
    }
    
    func setARView(_ arView: ARView) {
        self.arView = arView
        setupARConfiguration()
    }
    
    private func setupARConfiguration() {
        guard let arView = arView else { return }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .mesh
        configuration.environmentTexturing = .automatic
        configuration.planeDetection = [.horizontal, .vertical]
        
        arView.session.delegate = self
        arView.session.run(configuration)
    }
    
    private func processScanData() {
        Task {
            // Generate room dimensions
            roomDimensions = await generateRoomDimensions()
            
            // Detect architectural features
            detectedFeatures = await featureDetector.detectFeatures(from: meshAnchors, pointCloud: pointCloud)
            
            // Generate floor plan
            let floorPlan = await floorPlanGenerator.generateFloorPlan(
                from: meshAnchors,
                features: detectedFeatures,
                dimensions: roomDimensions
            )
            
            // Create scan data
            currentScan = ScanData(
                meshAnchors: meshAnchors,
                pointCloud: pointCloud,
                features: detectedFeatures,
                dimensions: roomDimensions,
                floorPlan: floorPlan,
                timestamp: Date()
            )
            
            hasCompletedScan = true
            
            // Save the scan data
            if let newScan = currentScan {
                storedScans.append(newScan)
                saveStoredScans()
            }
        }
    }
    
    private func generateRoomDimensions() async -> RoomDimensions {
        // Calculate room bounds from mesh data
        var minBounds = SIMD3<Float>(Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude)
        var maxBounds = SIMD3<Float>(-Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude)
        
        for anchor in meshAnchors {
            let vertices = anchor.geometry.vertices.asSIMD3(ofType: Float.self)
            for vertex in vertices {
                let worldVertex = anchor.transform * SIMD4<Float>(vertex.x, vertex.y, vertex.z, 1.0)
                minBounds = min(minBounds, SIMD3<Float>(worldVertex.x, worldVertex.y, worldVertex.z))
                maxBounds = max(maxBounds, SIMD3<Float>(worldVertex.x, worldVertex.y, worldVertex.z))
            }
        }
        
        let size = maxBounds - minBounds
        return RoomDimensions(
            width: max(size.x, 1.0),
            length: max(size.z, 1.0),
            height: max(size.y, 2.0),
            area: max(size.x * size.z, 1.0),
            volume: max(size.x * size.y * size.z, 1.0)
        )
    }
    
    // MARK: - Scan Data Storage
    
    func saveStoredScans() {
        ScanDataStorage.shared.saveScanData(storedScans)
    }
    
    func loadStoredScans() {
        if let loadedScans = ScanDataStorage.shared.loadScanData() {
            storedScans = loadedScans
        }
    }
    
    func clearStoredScans() {
        ScanDataStorage.shared.clearScanData()
        storedScans.removeAll()
    }
    
    // Mock ScanManager for previews
    static func mockScanManager() -> ScanManager {
        let mock = ScanManager()
        mock.detectedFeatures = [
            ArchitecturalFeature(type: .door, position: SIMD3<Float>(0, 0, 0), dimensions: SIMD3<Float>(0.8, 2.0, 0.1), confidence: 0.9, boundingBox: BoundingBox(min: SIMD3<Float>(0,0,0), max: SIMD3<Float>(0,0,0))),
            ArchitecturalFeature(type: .window, position: SIMD3<Float>(1, 1, 0), dimensions: SIMD3<Float>(1.2, 1.0, 0.1), confidence: 0.7, boundingBox: BoundingBox(min: SIMD3<Float>(0,0,0), max: SIMD3<Float>(0,0,0))),
            ArchitecturalFeature(type: .wall, position: SIMD3<Float>(2, 0, 0), dimensions: SIMD3<Float>(0.1, 2.5, 3.0), confidence: 0.95, boundingBox: BoundingBox(min: SIMD3<Float>(0,0,0), max: SIMD3<Float>(0,0,0)))
        ]
        return mock
    }
}

extension ScanManager: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor {
                meshAnchors.append(meshAnchor)
                updateScanProgress()
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor {
                if let index = meshAnchors.firstIndex(where: { $0.identifier == meshAnchor.identifier }) {
                    meshAnchors[index] = meshAnchor
                }
                updateScanProgress()
            }
        }
    }
    
    private func updateScanProgress() {
        // Simple progress calculation based on mesh anchor count
        scanProgress = min(Float(meshAnchors.count) / 20.0, 1.0)
    }
}