import SwiftUI

final class AppSettings: ObservableObject {
    @AppStorage("units") var units: Units = .metric
}

enum Units: String, CaseIterable, Identifiable, Codable {
    case metric, imperial
    var id: String { rawValue }
    var title: String { self == .metric ? "Metric (m, m²)" : "Imperial (ft, ft²)" }
    var lengthFactor: Double { self == .metric ? 1.0 : 3.28084 }
    var areaFactor: Double { self == .metric ? 1.0 : 10.7639 }
}

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    var body: some View {
        Form {
            Section("Units") {
                Picker("Measurement Units", selection: $settings.units) {
                    ForEach(Units.allCases) { u in
                        Text(u.title).tag(u)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Data") {
                NavigationLink {
                    Text("Backups coming soon.")
                        .padding()
                } label: { Label("Backups", systemImage: "externaldrive") }
            }
        }
        .navigationTitle("Settings")
    }
}
