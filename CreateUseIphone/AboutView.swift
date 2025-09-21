import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.and.flag.circle.fill").font(.system(size: 64))
            Text("RoomScan Pro – Cairns").font(.title).bold()
            Text("Built for professional real estate scanning in Cairns.").foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}
