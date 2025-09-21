import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ScanStore
    @State private var showingExporter = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        ScannerGatewayView()
                    } label: {
                        Label("Start New Scan", systemImage: "camera.viewfinder")
                            .foregroundStyle(.primary)
                    }
                    NavigationLink {
                        FloorPlanEditorView(plan: .constant(FloorPlan.sample()))
                    } label: {
                        Label("Open Editor (Sample)", systemImage: "square.and.pencil")
                    }
                }
                
                if !store.plans.isEmpty {
                    Section("Saved Floorplans") {
                        ForEach(store.plans) { plan in
                            NavigationLink {
                                FloorPlanEditorView(plan: .constant(plan))
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(plan.title).bold()
                                    Text(plan.subtitle).font(.footnote).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
                
                Section("More") {
                    NavigationLink { SettingsView() } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                    NavigationLink { AboutView() } label: {
                        Label("About", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("RoomScan Pro")
        }
    }
    
    func delete(at offsets: IndexSet) {
        store.delete(at: offsets)
    }
}
