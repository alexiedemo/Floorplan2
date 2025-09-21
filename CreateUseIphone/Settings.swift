import SwiftUI

final class AppSettings: ObservableObject {
    @AppStorage("units") var units: Units = .metric
}

enum Units: String, CaseIterable, Identifiable, Codable { case metric, imperial; var id: String { rawValue } }

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    var body: some View {
        Form {
            Section("Units") {
                Picker("Measurement Units", selection: $settings.units) {
                    Text("Metric (m, m²)").tag(Units.metric)
                    Text("Imperial (ft, ft²)").tag(Units.imperial)
                }
                .pickerStyle(.segmented)
            }
        }.navigationTitle("Settings")
    }
}
