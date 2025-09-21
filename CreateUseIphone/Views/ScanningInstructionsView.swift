import SwiftUI

struct ScanningInstructionsView: View {
    @Binding var showInstructions: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            // Header
            VStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text("Scanning Tips")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            // Instructions
            VStack(spacing: 20) {
                InstructionRow(
                    icon: "figure.walk",
                    title: "Move Slowly",
                    description: "Walk slowly around the room for better accuracy"
                )
                
                InstructionRow(
                    icon: "arrow.up.and.down.and.arrow.left.and.right",
                    title: "Cover All Areas",
                    description: "Point your device at walls, floors, and ceilings"
                )
                
                InstructionRow(
                    icon: "lightbulb.fill",
                    title: "Good Lighting",
                    description: "Ensure the room is well-lit for optimal results"
                )
                
                InstructionRow(
                    icon: "hand.raised.fill",
                    title: "Steady Hands",
                    description: "Keep your device steady while scanning"
                )
            }
            
            Spacer()
            
            Button("Got It!") {
                showInstructions = false
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

struct InstructionRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ScanningInstructionsView(showInstructions: .constant(true))
}