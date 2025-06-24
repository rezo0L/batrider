import Foundation

extension NumberFormatter {
    static func mockCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter
    }
}
