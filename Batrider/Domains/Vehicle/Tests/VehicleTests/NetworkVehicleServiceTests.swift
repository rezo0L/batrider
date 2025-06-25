import NetworkClient
@testable import Vehicle
import XCTest

class MockNetworkClient: NetworkClient {
    var result: Result<Vehicle, Error>?
    var lastEndpoint: Endpoint?

    func request<T>(endpoint: Endpoint) async throws -> T where T: Decodable {
        lastEndpoint = endpoint
        switch result {
        case let .success(vehicle as T):
            return vehicle
        case let .failure(error):
            throw error
        default:
            fatalError("MockNetworkClient result not set or type mismatch")
        }
    }
}

final class NetworkVehicleServiceTests: XCTestCase {
    func testFetchVehicleSuccess() async throws {
        let expectedVehicle = Vehicle(name: "TestCar", id: UUID(), category: "SUV", price: 10000, currency: "USD")
        let mockClient = MockNetworkClient()
        mockClient.result = .success(expectedVehicle)
        let service = NetworkVehicleService(client: mockClient)
        let vehicle = try await service.fetchVehicle(for: "id123")
        XCTAssertEqual(vehicle.name, expectedVehicle.name)
        XCTAssertEqual(vehicle.category, expectedVehicle.category)
        XCTAssertEqual(vehicle.price, expectedVehicle.price)
        XCTAssertEqual(vehicle.currency, expectedVehicle.currency)
    }

    func testFetchVehicleFailure() async {
        let mockClient = MockNetworkClient()
        mockClient.result = .failure(NetworkError.invalidResponse)
        let service = NetworkVehicleService(client: mockClient)

        do {
            _ = try await service.fetchVehicle(for: "id123")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError, "Expected NetworkError but got \(type(of: error))")
        }
    }
}
