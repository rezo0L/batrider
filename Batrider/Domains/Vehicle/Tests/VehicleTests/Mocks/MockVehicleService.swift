import Foundation
@testable import Vehicle

class MockVehicleService: VehicleService {
    var vehicle: Vehicle?
    var error: Error?

    init(vehicle: Vehicle? = nil, error: Error? = nil) {
        self.vehicle = vehicle
        self.error = error
    }

    func fetchVehicle(for identifier: String) async throws -> Vehicle {
        if let error {
            throw error
        }
        if let vehicle {
            return vehicle
        }
        throw NSError(domain: "MockServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock vehicle not set"])
    }
}
