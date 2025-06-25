import SwiftUI

/// Namespace for design system tokens.
public extension DesignSystem {
    /// Color tokens for the design system.
    enum Color {}
}

public extension DesignSystem.Color {
    /// Background color for views.
    static let background = Color(.systemBackground)
    /// Secondary background color for views.
    static let secondarySystemBackground = Color(.secondarySystemBackground)
    /// Overlay color for dimming backgrounds.
    static let overlay = Color.black.opacity(0.4)
    /// Overlay color with 25% opacity.
    static let overlay25 = Color.black.opacity(0.25)
    /// Border color for UI elements.
    static let border = Color.white
    /// Error color for error states.
    static let error = Color.red
    /// Accent color for highlights.
    static let accent = Color.accentColor
    /// Primary text color.
    static let primaryText = Color.primary
    /// Secondary text color.
    static let secondaryText = Color.secondary
    /// Button color for button backgrounds.
    static let button = Color.white
}
