import SwiftUI

struct FloorPlanEditorView: View {
    @Binding var plan: FloorPlan
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 0) {
            Canvas { ctx, size in drawPlan(plan, units: settings.units, in: ctx, size: size) }
                .background(Color(white: 0.975))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Button {
                    var r = Room(name: "New Room", corners: [V2(0,0), V2(3,0), V2(3,3), V2(0,3)])
                    r.computeArea()
                    plan.rooms.append(r)
                } label: { Label("Add Room", systemImage: "plus") }
                Spacer()
                NavigationLink { ExportView(plan: plan) } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }.brandedButtonProminent()
            }
            .padding()
        }
        .navigationTitle("Editor")
    }
}

func drawPlan(_ plan: FloorPlan, units: Units, in ctx: GraphicsContext, size: CGSize) {
    let padding: CGFloat = 16
    let maxW = size.width - 2*padding
    let maxH = size.height - 2*padding
    let allPts = plan.rooms.flatMap { $0.corners }
    guard !allPts.isEmpty else { return }
    let minX = allPts.map { $0.x }.min()!
    let maxX = allPts.map { $0.x }.max()!
    let minY = allPts.map { $0.y }.min()!
    let maxY = allPts.map { $0.y }.max()!
    let w = maxX - minX, h = maxY - minY
    let scale = min(maxW / max(w, 0.1), maxH / max(h, 0.1))
    func pt(_ v: V2) -> CGPoint {
        CGPoint(x: (v.x - minX) * scale + padding, y: (v.y - minY) * scale + padding)
    }
    for room in plan.rooms {
        var path = Path()
        let pts = room.corners.map { pt($0) }
        guard let first = pts.first else { continue }
        path.move(to: first)
        for p in pts.dropFirst() { path.addLine(to: p) }
        path.closeSubpath()
        ctx.stroke(path, with: .color(.black), lineWidth: 2)
        ctx.fill(path, with: .color(.blue.opacity(0.05)))
    }
}
