import Foundation
import ARKit
import SceneKit

struct ScanData: Identifiable, Codable {
    let id = UUID()
    let meshAnchors: [ARMeshAnchor]
    let pointCloud: [SIMD3<Float>]
    let features: [ArchitecturalFeature]
    let dimensions: RoomDimensions?
    let floorPlan: FloorPlan?
    let timestamp: Date
    
    enum CodingKeys: CodingKey {
        case id, pointCloud, features, dimensions, floorPlan, timestamp
    }
    
    init(meshAnchors: [ARMeshAnchor], pointCloud: [SIMD3<Float>], features: [ArchitecturalFeature], dimensions: RoomDimensions?, floorPlan: FloorPlan?, timestamp: Date) {
        self.meshAnchors = meshAnchors
        self.pointCloud = pointCloud
        self.features = features
        self.dimensions = dimensions
        self.floorPlan = floorPlan
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meshAnchors = [] // Cannot decode ARMeshAnchor directly
        self.pointCloud = try container.decode([SIMD3<Float>].self, forKey: .pointCloud)
        self.features = try container.decode([ArchitecturalFeature].self, forKey: .features)
        self.dimensions = try container.decodeIfPresent(RoomDimensions.self, forKey: .dimensions)
        self.floorPlan = try container.decodeIfPresent(FloorPlan.self, forKey: .floorPlan)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pointCloud, forKey: .pointCloud)
        try container.encode(features, forKey: .features)
        try container.encodeIfPresent(dimensions, forKey: .dimensions)
        try container.encodeIfPresent(floorPlan, forKey: .floorPlan)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

struct RoomDimensions: Codable {
    let width: Float  // meters
    let length: Float // meters
    let height: Float // meters
    let area: Float   // square meters
    let volume: Float // cubic meters
    
    var widthInFeet: Float { width * 3.28084 }
    var lengthInFeet: Float { length * 3.28084 }
    var heightInFeet: Float { height * 3.28084 }
    var areaInSquareFeet: Float { area * 10.7639 }
}

struct ArchitecturalFeature: Identifiable, Codable {
    let id = UUID()
    let type: FeatureType
    let position: SIMD3<Float>
    let dimensions: SIMD3<Float>
    let confidence: Float
    let boundingBox: BoundingBox
    
    enum FeatureType: String, CaseIterable, Codable {
        case door = "door"
        case window = "window"
        case opening = "opening"
        case wall = "wall"
        case corner = "corner"
        case ceiling = "ceiling"
        case floor = "floor"
    }
}

struct BoundingBox: Codable {
    let min: SIMD3<Float>
    let max: SIMD3<Float>
    
    var size: SIMD3<Float> { max - min }
    var center: SIMD3<Float> { (min + max) / 2 }
}

struct FloorPlan: Codable {
    let walls: [WallSegment]
    let openings: [Opening]
    let rooms: [Room]
    let scale: Float
    let bounds: BoundingBox
}

struct WallSegment: Codable {
    let start: SIMD2<Float>
    let end: SIMD2<Float>
    let thickness: Float
    let height: Float
}

struct Opening: Codable {
    let position: SIMD2<Float>
    let width: Float
    let type: ArchitecturalFeature.FeatureType
}

struct Room: Codable {
    let name: String
    let area: Float
    let perimeter: Float
    let corners: [SIMD2<Float>]
}