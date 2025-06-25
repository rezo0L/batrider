import NetworkClient
import SnapshotTesting
import XCTest

@testable import Vehicle

@MainActor
final class VehicleViewSnapshotTests: XCTestCase {
    private let uuid = UUID(uuidString: "2c978126-bdf8-488e-9865-3c8c8dbb3093") ?? .init()

    func testVehicleViewLoadedState() {
        let vehicle = Vehicle(name: "TestCar", id: uuid, category: "SUV", price: 10000, currency: "USD")
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: vehicle),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.vehicle = vehicle

        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
        assertSnapshot(of: view, as: .image)
    }

    func testVehicleViewLoadingState() {
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: nil),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.isLoading = true

        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
        assertSnapshot(of: view, as: .image)
    }

    func testVehicleViewErrorState() {
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: nil, error: NetworkError.invalidResponse),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.errorMessage = "Error!"

        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
        assertSnapshot(of: view, as: .image)
    }

    func testVehicleViewLongText() {
        let vehicle = Vehicle(
            name: String(repeating: "VeryLongVehicleName", count: 5),
            id: UUID(uuidString: "2c978126-bdf8-488e-9865-3c8c8dbb3093") ?? .init(),
            category: String(repeating: "CategoryWithLongName", count: 3),
            price: 10000,
            currency: "USD"
        )
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: vehicle),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.vehicle = vehicle
        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
        assertSnapshot(of: view, as: .image)
    }

    func testVehicleViewDifferentCurrency() {
        let vehicle = Vehicle(name: "TestCar", id: uuid, category: "SUV", price: 10000, currency: "SEK")
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: vehicle),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.vehicle = vehicle
        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
        assertSnapshot(of: view, as: .image)
    }

    func testVehicleViewDarkMode() {
        let vehicle = Vehicle(name: "TestCar", id: uuid, category: "SUV", price: 10000, currency: "USD")
        let viewModel = VehicleViewModel(vehicleId: "id123",
                                         service: MockVehicleService(vehicle: vehicle),
                                         currencyFormatter: .mockCurrencyFormatter())
        viewModel.vehicle = vehicle
        let view = VehicleView(viewModel: viewModel)
            .frame(width: 390, height: 844)
            .environment(\.colorScheme, .dark)
        assertSnapshot(of: view, as: .image)
    }
}
