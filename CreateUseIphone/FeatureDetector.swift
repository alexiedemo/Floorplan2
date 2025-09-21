import Foundation
import ARKit
import RealityKit

class FeatureDetector {
    
    func detectFeatures(from meshAnchors: [ARMeshAnchor], pointCloud: [SIMD3<Float>]) async -> [ArchitecturalFeature] {
        var features: [ArchitecturalFeature] = []
        
        // Detect walls, floors, and ceilings from mesh data
        for meshAnchor in meshAnchors {
            let detectedFeatures = analyzeGeometry(meshAnchor: meshAnchor)
            features.append(contentsOf: detectedFeatures)
        }
        
        // Detect openings (doors and windows) by analyzing gaps in walls
        let openings = detectOpenings(from: features)
        features.append(contentsOf: openings)
        
        return features
    }
    
    private func analyzeGeometry(meshAnchor: ARMeshAnchor) -> [ArchitecturalFeature] {
        var features: [ArchitecturalFeature] = []
        let mesh = meshAnchor.geometry
        let vertices = mesh.vertices.asSIMD3(ofType: Float.self)
        let normals = mesh.normals.asSIMD3(ofType: Float.self)
        
        // Calculate bounding box
        let bounds = calculateBoundingBox(vertices: vertices, transform: meshAnchor.transform)
        
        // Classify surface based on normal vectors
        let avgNormal = calculateAverageNormal(normals: normals)
        let featureType = classifySurface(normal: avgNormal, bounds: bounds)
        
        let feature = ArchitecturalFeature(
            type: featureType,
            position: bounds.center,
            dimensions: bounds.size,
            confidence: 0.8,
            boundingBox: bounds
        )
        
        features.append(feature)
        return features
    }
    
    private func detectOpenings(from features: [ArchitecturalFeature]) -> [ArchitecturalFeature] {
        var openings: [ArchitecturalFeature] = []
        
        // Simple opening detection based on gaps in wall features
        let walls = features.filter { $0.type == .wall }
        
        for wall in walls {
            // Check for potential door openings (bottom of wall)
            if wall.position.y < 0.1 && wall.dimensions.y > 1.8 {
                let doorOpening = ArchitecturalFeature(
                    type: .door,
                    position: SIMD3<Float>(wall.position.x, 0, wall.position.z),
                    dimensions: SIMD3<Float>(0.8, 2.0, 0.1),
                    confidence: 0.6,
                    boundingBox: BoundingBox(
                        min: SIMD3<Float>(wall.position.x - 0.4, 0, wall.position.z - 0.05),
                        max: SIMD3<Float>(wall.position.x + 0.4, 2.0, wall.position.z + 0.05)
                    )
                )
                openings.append(doorOpening)
            }
            
            // Check for potential window openings (middle of wall)
            if wall.position.y > 0.5 && wall.position.y < 2.0 {
                let windowOpening = ArchitecturalFeature(
                    type: .window,
                    position: SIMD3<Float>(wall.position.x, wall.position.y, wall.position.z),
                    dimensions: SIMD3<Float>(1.0, 1.0, 0.1),
                    confidence: 0.5,
                    boundingBox: BoundingBox(
                        min: SIMD3<Float>(wall.position.x - 0.5, wall.position.y - 0.5, wall.position.z - 0.05),
                        max: SIMD3<Float>(wall.position.x + 0.5, wall.position.y + 0.5, wall.position.z + 0.05)
                    )
                )
                openings.append(windowOpening)
            }
        }
        
        return openings
    }
    
    private func calculateBoundingBox(vertices: [SIMD3<Float>], transform: simd_float4x4) -> BoundingBox {
        guard !vertices.isEmpty else {
            return BoundingBox(min: SIMD3<Float>(0, 0, 0), max: SIMD3<Float>(0, 0, 0))
        }
        
        var minBounds = SIMD3<Float>(Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude)
        var maxBounds = SIMD3<Float>(-Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude)
        
        for vertex in vertices {
            let worldVertex = transform * SIMD4<Float>(vertex.x, vertex.y, vertex.z, 1.0)
            let worldPos = SIMD3<Float>(worldVertex.x, worldVertex.y, worldVertex.z)
            minBounds = min(minBounds, worldPos)
            maxBounds = max(maxBounds, worldPos)
        }
        
        return BoundingBox(min: minBounds, max: maxBounds)
    }
    
    private func calculateAverageNormal(normals: [SIMD3<Float>]) -> SIMD3<Float> {
        guard !normals.isEmpty else { return SIMD3<Float>(0, 1, 0) }
        
        let sum = normals.reduce(SIMD3<Float>(0, 0, 0)) { $0 + $1 }
        return normalize(sum)
    }
    
    private func classifySurface(normal: SIMD3<Float>, bounds: BoundingBox) -> ArchitecturalFeature.FeatureType {
        let upVector = SIMD3<Float>(0, 1, 0)
        let downVector = SIMD3<Float>(0, -1, 0)
        
        let upDot = dot(normal, upVector)
        let downDot = dot(normal, downVector)
        
        // Floor detection (normal pointing up)
        if upDot > 0.8 {
            return .floor
        }
        
        // Ceiling detection (normal pointing down)
        if downDot > 0.8 {
            return .ceiling
        }
        
        // Wall detection (normal mostly horizontal)
        if abs(normal.y) < 0.5 {
            return .wall
        }
        
        return .wall // Default to wall
    }
}