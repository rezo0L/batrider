import SwiftUI

@MainActor
class VehicleViewModel: ObservableObject {
    @Published var vehicle: Vehicle?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let vehicleId: String
    private let service: VehicleService
    private let currencyFormatter: NumberFormatter

    init(vehicleId: String,
         service: VehicleService = NetworkVehicleService(),
         currencyFormatter: NumberFormatter = .defaultCurrencyFormatter())
    {
        self.vehicleId = vehicleId
        self.service = service
        self.currencyFormatter = currencyFormatter
    }

    func fetchVehicle() async {
        isLoading = true
        errorMessage = nil
        vehicle = nil

        do {
            let fetchedVehicle = try await service.fetchVehicle(for: vehicleId)
            vehicle = fetchedVehicle
        } catch {
            errorMessage = String(format: .fetchVehicleError, error.localizedDescription)
        }

        isLoading = false
    }

    var name: String? { vehicle?.name }
    var category: String? { vehicle?.category }
    var id: String? { vehicle?.id.uuidString.split(separator: "-").last.map(String.init) }

    var formattedPrice: String? {
        guard let vehicle = vehicle else { return nil }

        currencyFormatter.currencyCode = vehicle.currency
        return currencyFormatter.string(from: NSNumber(value: vehicle.price)) ?? "\(vehicle.price)"
    }
}
