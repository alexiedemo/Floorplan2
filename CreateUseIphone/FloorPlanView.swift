import SwiftUI

struct FloorPlanView: View {
    let scanData: ScanData?
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if let floorPlan = scanData?.floorPlan {
                    FloorPlanCanvas(floorPlan: floorPlan, scale: scale, offset: offset)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .simultaneously(with:
                                    DragGesture()
                                        .onChanged { value in
                                            offset = value.translation
                                        }
                                )
                        )
                } else {
                    VStack {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No floor plan available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Floor Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        withAnimation {
                            scale = 1.0
                            offset = .zero
                        }
                    }
                }
            }
        }
    }
}

struct FloorPlanCanvas: View {
    let floorPlan: FloorPlan
    let scale: CGFloat
    let offset: CGSize
    
    var body: some View {
        Canvas { context, size in
            // Draw coordinate system
            drawCoordinateSystem(context: context, size: size)
            
            // Draw walls
            drawWalls(context: context, size: size, walls: floorPlan.walls)
            
            // Draw openings
            drawOpenings(context: context, size: size, openings: floorPlan.openings)
            
            // Draw dimensions
            drawDimensions(context: context, size: size)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func drawCoordinateSystem(context: GraphicsContext, size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Draw grid
        context.stroke(
            Path { path in
                let gridSpacing: CGFloat = 50
                
                // Vertical lines
                for i in stride(from: -size.width/2, through: size.width/2, by: gridSpacing) {
                    path.move(to: CGPoint(x: center.x + i, y: 0))
                    path.addLine(to: CGPoint(x: center.x + i, y: size.height))
                }
                
                // Horizontal lines
                for i in stride(from: -size.height/2, through: size.height/2, by: gridSpacing) {
                    path.move(to: CGPoint(x: 0, y: center.y + i))
                    path.addLine(to: CGPoint(x: size.width, y: center.y + i))
                }
            },
            with: .color(.gray.opacity(0.2)),
            lineWidth: 0.5
        )
    }
    
    private func drawWalls(context: GraphicsContext, size: CGSize, walls: [WallSegment]) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let scaleFactor: CGFloat = 100 // 1 meter = 100 points
        
        for wall in walls {
            let startPoint = CGPoint(
                x: center.x + CGFloat(wall.start.x) * scaleFactor,
                y: center.y - CGFloat(wall.start.y) * scaleFactor // Flip Y axis
            )
            
            let endPoint = CGPoint(
                x: center.x + CGFloat(wall.end.x) * scaleFactor,
                y: center.y - CGFloat(wall.end.y) * scaleFactor // Flip Y axis
            )
            
            context.stroke(
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                },
                with: .color(.primary),
                style: StrokeStyle(lineWidth: CGFloat(wall.thickness) * scaleFactor, lineCap: .round)
            )
        }
    }
    
    private func drawOpenings(context: GraphicsContext, size: CGSize, openings: [Opening]) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let scaleFactor: CGFloat = 100
        
        for opening in openings {
            let position = CGPoint(
                x: center.x + CGFloat(opening.position.x) * scaleFactor,
                y: center.y - CGFloat(opening.position.y) * scaleFactor
            )
            
            let width = CGFloat(opening.width) * scaleFactor
            let color: Color = opening.type == .door ? .blue : .green
            
            // Draw opening indicator
            context.fill(
                Path { path in
                    path.addEllipse(in: CGRect(
                        x: position.x - width/2,
                        y: position.y - 5,
                        width: width,
                        height: 10
                    ))
                },
                with: .color(color.opacity(0.6))
            )
            
            // Draw opening label
            let text = opening.type == .door ? "D" : "W"
            context.draw(
                Text(text)
                    .font(.caption)
                    .foregroundColor(color),
                at: position
            )
        }
    }
    
    private func drawDimensions(context: GraphicsContext, size: CGSize) {
        // Add dimension lines and measurements
        // This would show room measurements along the walls
        // Implementation details would depend on specific requirements
    }
}

#Preview {
    FloorPlanView(scanData: nil)
}