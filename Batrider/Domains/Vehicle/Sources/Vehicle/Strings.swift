import Foundation

extension String {
    static let vehicleNamePlaceholder = String(localized: "Vehicle Name", comment: "Placeholder for vehicle name")
    static let categoryPlaceholder = String(localized: "Category", comment: "Placeholder for vehicle category")
    static let pricePlaceholder = String(localized: "$0.00", comment: "Placeholder for price")
    static let vehicleIDTitle = String(localized: "Vehicle ID", comment: "Title for vehicle ID row")
    static let vehicleIDPlaceholder = String(localized: "N/A", comment: "Placeholder for missing vehicle ID")
    static let retryButton = String(localized: "Retry", comment: "Retry button title")
    static let fetchVehicleError = String(localized: "Failed to fetch vehicle details: %@", comment: "Error message for failed vehicle fetch")
    static let scanningFailedTitle = String(localized: "Scanning Failed", comment: "Title for scanning failed alert")
    static let okButton = String(localized: "OK", comment: "OK button title for alerts")
}
