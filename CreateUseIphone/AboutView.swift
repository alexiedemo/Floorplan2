import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.and.flag.circle.fill").font(.system(size: 64)).foregroundStyle(Brand.primary)
            Text("RoomScan Pro – Cairns").font(.title).bold()
            Text("Built for professional real estate scanning in Cairns.").foregroundStyle(.secondary)
            Link("Support", destination: URL(string: "mailto:alexie@twomeyschriber.com.au")!)
                .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}
