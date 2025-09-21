import SwiftUI

struct CardStyle: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(
        backgroundColor: Color = Color(.systemGray6),
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 2
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 1)
    }
}

extension View {
    func cardStyle(
        backgroundColor: Color = Color(.systemGray6),
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 2
    ) -> some View {
        modifier(CardStyle(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius
        ))
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Card with default style")
            .cardStyle()
        
        Text("Card with custom style")
            .cardStyle(
                backgroundColor: .blue.opacity(0.1),
                cornerRadius: 20,
                shadowRadius: 5
            )
    }
    .padding()
}