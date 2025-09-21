import Foundation
import ARKit

class FloorPlanGenerator {
    
    func generateFloorPlan(
        from meshAnchors: [ARMeshAnchor],
        features: [ArchitecturalFeature],
        dimensions: RoomDimensions?
    ) async -> FloorPlan? {
        
        guard let dimensions = dimensions else { return nil }
        
        // Generate wall segments from detected features
        let walls = generateWallSegments(from: features, dimensions: dimensions)
        
        // Generate openings (doors and windows)
        let openings = generateOpenings(from: features)
        
        // Generate room information
        let rooms = generateRooms(from: walls, dimensions: dimensions)
        
        // Calculate bounds
        let bounds = calculateFloorPlanBounds(walls: walls, dimensions: dimensions)
        
        return FloorPlan(
            walls: walls,
            openings: openings,
            rooms: rooms,
            scale: 1.0, // 1 unit = 1 meter
            bounds: bounds
        )
    }
    
    private func generateWallSegments(from features: [ArchitecturalFeature], dimensions: RoomDimensions) -> [WallSegment] {
        var walls: [WallSegment] = []
        
        // Create perimeter walls based on room dimensions
        let halfWidth = dimensions.width / 2
        let halfLength = dimensions.length / 2
        
        // Front wall
        walls.append(WallSegment(
            start: SIMD2<Float>(-halfWidth, -halfLength),
            end: SIMD2<Float>(halfWidth, -halfLength),
            thickness: 0.1,
            height: dimensions.height
        ))
        
        // Right wall
        walls.append(WallSegment(
            start: SIMD2<Float>(halfWidth, -halfLength),
            end: SIMD2<Float>(halfWidth, halfLength),
            thickness: 0.1,
            height: dimensions.height
        ))
        
        // Back wall
        walls.append(WallSegment(
            start: SIMD2<Float>(halfWidth, halfLength),
            end: SIMD2<Float>(-halfWidth, halfLength),
            thickness: 0.1,
            height: dimensions.height
        ))
        
        // Left wall
        walls.append(WallSegment(
            start: SIMD2<Float>(-halfWidth, halfLength),
            end: SIMD2<Float>(-halfWidth, -halfLength),
            thickness: 0.1,
            height: dimensions.height
        ))
        
        return walls
    }
    
    private func generateOpenings(from features: [ArchitecturalFeature]) -> [Opening] {
        var openings: [Opening] = []
        
        let doorAndWindowFeatures = features.filter { $0.type == .door || $0.type == .window }
        
        for feature in doorAndWindowFeatures {
            let opening = Opening(
                position: SIMD2<Float>(feature.position.x, feature.position.z),
                width: feature.dimensions.x,
                type: feature.type
            )
            openings.append(opening)
        }
        
        return openings
    }
    
    private func generateRooms(from walls: [WallSegment], dimensions: RoomDimensions) -> [Room] {
        // For now, create a single room representing the entire scanned space
        let corners = [
            SIMD2<Float>(-dimensions.width/2, -dimensions.length/2),
            SIMD2<Float>(dimensions.width/2, -dimensions.length/2),
            SIMD2<Float>(dimensions.width/2, dimensions.length/2),
            SIMD2<Float>(-dimensions.width/2, dimensions.length/2)
        ]
        
        let room = Room(
            name: "Main Room",
            area: dimensions.area,
            perimeter: 2 * (dimensions.width + dimensions.length),
            corners: corners
        )
        
        return [room]
    }
    
    private func calculateFloorPlanBounds(walls: [WallSegment], dimensions: RoomDimensions) -> BoundingBox {
        let halfWidth = dimensions.width / 2
        let halfLength = dimensions.length / 2
        
        return BoundingBox(
            min: SIMD3<Float>(-halfWidth, 0, -halfLength),
            max: SIMD3<Float>(halfWidth, dimensions.height, halfLength)
        )
    }
}