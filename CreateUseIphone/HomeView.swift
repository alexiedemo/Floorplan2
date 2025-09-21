import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ScanStore
    @State private var showingExporter = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Actions") {
                    NavigationLink {
                        ScannerGatewayView()
                    } label: {
                        Label("Start New Scan", systemImage: "camera.viewfinder")
                    }
                    NavigationLink {
                        FloorPlanEditorView(plan: .constant(FloorPlan.sample()))
                    } label: {
                        Label("Open Editor (Sample)", systemImage: "square.and.pencil")
                    }
                }
                
                if !store.plans.isEmpty {
                    Section("Saved Floorplans") {
                        ForEach(store.plans) {{ plan in
                            NavigationLink {
                                FloorPlanDetailView(plan: plan)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(plan.title).bold()
                                    Text(plan.subtitle).font(.footnote).foregroundStyle(.secondary)
                                }
                            }
                        }}
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("RoomScan Pro")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingExporter = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }.disabled(store.plans.isEmpty)
                }
            }
            .sheet(isPresented: $showingExporter) {
                if let last = store.plans.last {
                    ExportView(plan: last)
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        store.delete(at: offsets)
    }
}

#Preview {
    HomeView().environmentObject(ScanStore())
}
