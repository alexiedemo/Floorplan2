import SwiftUI

struct FloorPlanDetailView: View {
    let plan: FloorPlan
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Title", value: plan.title)
                LabeledContent("Created", value: plan.createdAt.formatted())
                LabeledContent("Rooms", value: "\(plan.rooms.count)")
                LabeledContent("Total Area", value: formattedArea(plan.totalArea()))
            }
            Section("Export") {
                NavigationLink { ExportView(plan: plan) } label: {
                    Label("Export Floorplan", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("Floorplan")
    }
    
    func formattedArea(_ a: Double) -> String {
        switch settings.units {
        case .metric: return String(format: "%.1f m²", a)
        case .imperial: return String(format: "%.1f ft²", a * 10.7639)
        }
    }
}
