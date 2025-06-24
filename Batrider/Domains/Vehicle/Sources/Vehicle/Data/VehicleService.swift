protocol VehicleService {
    func fetchVehicle(for identifier: String) async throws -> Vehicle
}
