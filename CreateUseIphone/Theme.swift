import SwiftUI

enum Brand {
    static let primary = Color("BrandPrimary")
    static let secondary = Color("BrandSecondary")
}

extension View {
    func brandedButtonProminent() -> some View {
        self.buttonStyle(.borderedProminent).tint(Brand.primary)
    }
}
