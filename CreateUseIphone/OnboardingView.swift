import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    var body: some View {
        TabView {
            OnboardPage(title: "Welcome to RoomScan Pro – Cairns",
                        subtitle: "Scan rooms with LiDAR, generate clean floorplans, and export as SVG/PDF.",
                        systemImage: "house.lodge")
            OnboardPage(title: "Fast & Accurate",
                        subtitle: "Powered by Apple's RoomPlan on supported devices. Works offline.",
                        systemImage: "speedometer")
            OnboardPage(title: "Export & Share",
                        subtitle: "Send floorplans as SVG, PDF, JSON, or CSV to clients and trades.",
                        systemImage: "square.and.arrow.up")
        }
        .tabViewStyle(.page)
        .overlay(alignment: .bottom) {
            Button("Get Started") { hasOnboarded = true }
                .brandedButtonProminent()
                .padding()
        }
    }
}

struct OnboardPage: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundStyle(Brand.primary)
            Text(title).font(.title).bold()
            Text(subtitle).multilineTextAlignment(.center).foregroundStyle(.secondary).padding(.horizontal)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
