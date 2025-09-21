import SwiftUI
import ARKit
import RealityKit

struct ARScanView: UIViewRepresentable {
    @ObservedObject var scanManager: ScanManager
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        scanManager.setARView(arView)
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true
        
        arView.addSubview(coachingOverlay)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.leadingAnchor)
        ])
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update mesh visualization
        updateMeshVisualization(uiView)
    }
    
    private func updateMeshVisualization(_ arView: ARView) {
        // Remove existing mesh entities
        arView.scene.anchors.removeAll()
        
        // Add mesh visualization for each anchor
        for meshAnchor in scanManager.meshAnchors {
            let meshEntity = createMeshEntity(from: meshAnchor)
            let anchorEntity = AnchorEntity(anchor: meshAnchor)
            anchorEntity.addChild(meshEntity)
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    private func createMeshEntity(from meshAnchor: ARMeshAnchor) -> ModelEntity {
        let mesh = meshAnchor.geometry
        var meshResource: MeshResource
        
        do {
            meshResource = try MeshResource.generate(from: mesh)
        } catch {
            print("Failed to create mesh resource: \(error)")
            return ModelEntity()
        }
        
        var material = SimpleMaterial()
        material.color = .init(tint: .blue.withAlphaComponent(0.3))
        material.isMetallic = false
        material.roughness = 1.0
        
        let modelEntity = ModelEntity(mesh: meshResource, materials: [material])
        return modelEntity
    }
}