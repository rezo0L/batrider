import CoreGraphics

/// Namespace for design system tokens.
public extension DesignSystem {
    /// Layout tokens for the design system.
    enum Layout {}
}

public extension DesignSystem.Layout {
    /// Standard vertical spacing between elements.
    static let verticalSpacing: CGFloat = 20
    /// Standard horizontal padding for containers.
    static let horizontalPadding: CGFloat = 30
    /// Spacing between sections.
    static let sectionSpacing: CGFloat = 16
    /// Default padding for UI elements.
    static let defaultPadding: CGFloat = 16
    /// Standard corner radius for rounded elements.
    static let cornerRadius: CGFloat = 20
    /// Standard border width for bordered elements.
    static let borderWidth: CGFloat = 2
    /// Small padding for compact UI elements.
    static let smallPadding: CGFloat = 8
    /// Medium padding for medium-sized UI elements.
    static let mediumPadding: CGFloat = 20
    /// Large padding for large UI elements.
    static let largePadding: CGFloat = 56
    /// Double the standard vertical spacing.
    static let doubleVerticalSpacing: CGFloat = 40
}
