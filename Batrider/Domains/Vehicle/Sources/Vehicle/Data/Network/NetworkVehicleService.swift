import NetworkClient

class NetworkVehicleService: VehicleService {
    private let client: NetworkClient

    init(client: NetworkClient = URLSessionClient()) {
        self.client = client
    }

    func fetchVehicle(for identifier: String) async throws -> Vehicle {
        let endpoint = VehicleEndpoint.fetch(identifier: identifier)
        return try await client.request(endpoint: endpoint)
    }
}
