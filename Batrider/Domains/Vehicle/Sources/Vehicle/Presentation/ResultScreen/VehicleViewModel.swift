import SwiftUI

@MainActor
class VehicleViewModel: ObservableObject {
    @Published var vehicle: Vehicle?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let vehicleId: String
    private let service: VehicleService

    init(vehicleId: String, service: VehicleService = NetworkVehicleService()) {
        self.vehicleId = vehicleId
        self.service = service
    }

    func fetchVehicle() async {
        isLoading = true
        errorMessage = nil
        vehicle = nil

        do {
            let fetchedVehicle = try await service.fetchVehicle(for: vehicleId)
            self.vehicle = fetchedVehicle
        } catch {
            self.errorMessage = "Failed to fetch vehicle details: \(error.localizedDescription)"
        }

        self.isLoading = false
    }

    var name: String? { vehicle?.name }
    var category: String? { vehicle?.category }
    var id: String? { vehicle?.id.uuidString.split(separator: "-").last.map(String.init) }

    var formattedPrice: String? {
        guard let vehicle = vehicle else { return nil }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = vehicle.currency
        formatter.maximumFractionDigits = 2
        formatter.locale = .current
        return formatter.string(from: NSNumber(value: vehicle.price)) ?? "\(vehicle.price)"
    }
}
