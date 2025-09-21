import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct ExportView: View {
    let plan: FloorPlan
    @State private var showingShare = false
    @State private var exportURL: URL?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Export Floorplan").font(.title3).bold()
            VStack(spacing: 8) {
                Button { exportURL = SVGExporter().export(plan: plan); showingShare = true } label: {
                    Label("Export SVG", systemImage: "square.and.arrow.down")
                }
                Button { exportURL = PDFExporter().export(plan: plan); showingShare = true } label: {
                    Label("Export PDF", systemImage: "doc.richtext")
                }
                Button { exportURL = JSONExporter().export(plan: plan); showingShare = true } label: {
                    Label("Export JSON", systemImage: "curlybraces")
                }
                Button { exportURL = CSVExporter().export(plan: plan); showingShare = true } label: {
                    Label("Export CSV", systemImage: "tablecells")
                }
            }
        }
        .padding()
        .sheet(isPresented: $showingShare) {
            if let url = exportURL { ShareSheet(items: [url]) }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct JSONExporter {
    func export(plan: FloorPlan) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("floorplan.json")
        do { let data = try JSONEncoder().encode(plan); try data.write(to: url); return url } catch { return nil }
    }
}

struct CSVExporter {
    func export(plan: FloorPlan) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("floorplan.csv")
        var csv = "Room,Area(m2),Corners\n"
        for r in plan.rooms {
            let pts = r.corners.map { "(\($0.x),\($0.y))" }.joined(separator: " ")
            csv += "\(r.name),\(String(format: "%.2f", r.area)),\(pts)\n"
        }
        do { try csv.data(using: .utf8)?.write(to: url); return url } catch { return nil }
    }
}

struct SVGExporter {
    func export(plan: FloorPlan) -> URL? {
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("floorplan.svg")
        let svg = SVGRenderer().render(plan: plan, size: CGSize(width: 1200, height: 800))
        try? svg.data(using: .utf8)?.write(to: temp)
        return temp
    }
}

struct PDFExporter {
    func export(plan: FloorPlan) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("floorplan.pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 1200, height: 800))
        do {
            try renderer.writePDF(to: url) { ctx in
                ctx.beginPage()
                let view = FloorPlanPDFView(plan: plan)
                view.drawHierarchy(in: CGRect(x: 0, y: 0, width: 1200, height: 800), afterScreenUpdates: true)
            }
            return url
        } catch { return nil }
    }
}

final class FloorPlanPDFView: UIView {
    let plan: FloorPlan
    init(plan: FloorPlan) { self.plan = plan; super.init(frame: .zero); backgroundColor = .white }
    required init?(coder: NSCoder) { fatalError() }
    override func draw(_ rect: CGRect) {
        // Simple draw
        let padding: CGFloat = 40, maxW = rect.width - 2*padding, maxH = rect.height - 2*padding
        let allPts = plan.rooms.flatMap { $0.corners }; guard !allPts.isEmpty else { return }
        let minX = allPts.map { $0.x }.min()!, maxX = allPts.map { $0.x }.max()!
        let minY = allPts.map { $0.y }.min()!, maxY = allPts.map { $0.y }.max()!
        let w = maxX - minX, h = maxY - minY
        let scale = min(maxW / max(w, 0.1), maxH / max(h, 0.1))
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor); ctx.fill(rect)
        ctx.setStrokeColor(UIColor.black.cgColor); ctx.setLineWidth(2)
        func pt(_ v: V2) -> CGPoint { CGPoint(x: (v.x - minX) * scale + padding, y: (v.y - minY) * scale + padding) }
        for room in plan.rooms {
            let pts = room.corners.map { pt($0) }
            guard let first = pts.first else { continue }
            ctx.beginPath(); ctx.move(to: first); for p in pts.dropFirst() { ctx.addLine(to: p) }; ctx.closePath()
            ctx.setFillColor(UIColor.systemBlue.withAlphaComponent(0.08).cgColor)
            ctx.drawPath(using: .fillStroke)
        }
    }
}

struct SVGRenderer {
    func render(plan: FloorPlan, size: CGSize) -> String {
        let padding: CGFloat = 16, maxW = size.width - 2*padding, maxH = size.height - 2*padding
        let all = plan.rooms.flatMap { $0.corners }
        guard !all.isEmpty else { return "<svg xmlns='http://www.w3.org/2000/svg' width='\(Int(size.width))' height='\(Int(size.height))'/>" }
        let minX = all.map { $0.x }.min()!, maxX = all.map { $0.x }.max()!
        let minY = all.map { $0.y }.min()!, maxY = all.map { $0.y }.max()!
        let w = maxX - minX, h = maxY - minY
        let scale = min(maxW / max(w, 0.1), maxH / max(h, 0.1))
        func pt(_ v: V2) -> (Double, Double) { let x = (v.x - minX) * Double(scale) + Double(padding); let y = (v.y - minY) * Double(scale) + Double(padding); return (x, y) }
        var shapes: [String] = []
        for room in plan.rooms {
            let points = room.corners.map { p -> String in let (x,y) = pt(p); return "\(x),\(y)" }.joined(separator: " ")
            shapes.append("<polygon points='\(points)' stroke='black' stroke-width='2' fill='rgba(0,122,255,0.08)'/>")
        }
        return """<svg xmlns='http://www.w3.org/2000/svg' width='\(Int(size.width))' height='\(Int(size.height))'>\(shapes.joined())</svg>"""
    }
}
