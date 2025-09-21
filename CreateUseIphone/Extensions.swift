import Foundation
import ARKit
import SceneKit

// MARK: - ARGeometry Extensions
extension ARGeometrySource {
    func asSIMD3(ofType type: Float.Type) -> [SIMD3<Float>] {
        assert(componentsPerVector == 3, "Geometry source must have 3 components per vector")
        
        return (0..<count).map { index in
            let offset = index * stride
            let x = buffer.contents().load(fromByteOffset: offset, as: Float.self)
            let y = buffer.contents().load(fromByteOffset: offset + 4, as: Float.self)
            let z = buffer.contents().load(fromByteOffset: offset + 8, as: Float.self)
            return SIMD3<Float>(x, y, z)
        }
    }
    
    func asSCNVector3Array() -> [SCNVector3] {
        assert(componentsPerVector == 3, "Geometry source must have 3 components per vector")
        
        return (0..<count).map { index in
            let offset = index * stride
            let x = buffer.contents().load(fromByteOffset: offset, as: Float.self)
            let y = buffer.contents().load(fromByteOffset: offset + 4, as: Float.self)
            let z = buffer.contents().load(fromByteOffset: offset + 8, as: Float.self)
            return SCNVector3(x, y, z)
        }
    }
}

extension ARGeometryElement {
    func asSCNGeometryElement() -> SCNGeometryElement {
        let indexCount = count
        let indexData = buffer
        
        return SCNGeometryElement(
            data: indexData,
            primitiveType: .triangles,
            primitiveCount: indexCount / 3,
            bytesPerIndex: bytesPerIndex
        )
    }
}

// MARK: - SIMD Extensions
extension SIMD3 where Scalar == Float {
    static func min(_ lhs: SIMD3<Float>, _ rhs: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(
            Swift.min(lhs.x, rhs.x),
            Swift.min(lhs.y, rhs.y),
            Swift.min(lhs.z, rhs.z)
        )
    }
    
    static func max(_ lhs: SIMD3<Float>, _ rhs: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(
            Swift.max(lhs.x, rhs.x),
            Swift.max(lhs.y, rhs.y),
            Swift.max(lhs.z, rhs.z)
        )
    }
}

// MARK: - SCNMatrix4 Extensions
extension SCNMatrix4 {
    init(_ transform: simd_float4x4) {
        self.init(
            m11: transform.columns.0.x, m12: transform.columns.1.x, m13: transform.columns.2.x, m14: transform.columns.3.x,
            m21: transform.columns.0.y, m22: transform.columns.1.y, m23: transform.columns.2.y, m24: transform.columns.3.y,
            m31: transform.columns.0.z, m32: transform.columns.1.z, m33: transform.columns.2.z, m34: transform.columns.3.z,
            m41: transform.columns.0.w, m42: transform.columns.1.w, m43: transform.columns.2.w, m44: transform.columns.3.w
        )
    }
}