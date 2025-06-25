import UIKit

/// Namespace for design system tokens.
public extension DesignSystem {
    /// Font tokens for the design system.
    enum Font {}
}

public extension DesignSystem.Font {
    /// Large, bold title font.
    static let title = UIFont.systemFont(ofSize: 28, weight: .bold)
    /// Medium, medium-weight subtitle font.
    static let subtitle = UIFont.systemFont(ofSize: 20, weight: .medium)
    /// Standard body font.
    static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
    /// Semibold button font.
    static let button = UIFont.systemFont(ofSize: 17, weight: .semibold)
    /// Small caption font.
    static let caption = UIFont.systemFont(ofSize: 13, weight: .regular)
    /// Large, heavy price font.
    static let price = UIFont.systemFont(ofSize: 40, weight: .heavy)
    /// Monospaced detail font.
    static let detail = UIFont.monospacedSystemFont(ofSize: 17, weight: .regular)
    /// Headline style font for detail titles.
    static let detailTitle = UIFont.preferredFont(forTextStyle: .headline)
}
