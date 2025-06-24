import Testing
import Foundation
@testable import Vehicle

@MainActor
final class VehicleViewModelTests {
    var viewModel: VehicleViewModel!
    var mockService: MockVehicleService!

    func setUp() {
        mockService = MockVehicleService()
        viewModel = VehicleViewModel(vehicleId: "123", service: mockService)
    }

    @Test
    func testInitialState() {
        setUp()
        #expect(viewModel.vehicle == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testFetchVehicleSuccess() async {
        setUp()
        let expectedVehicle = Vehicle(name: "Test Vehicle", id: UUID(), category: "Test", price: 99.99, currency: "SEK")
        mockService.vehicle = expectedVehicle
        await viewModel.fetchVehicle()
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.vehicle?.id == expectedVehicle.id)
        #expect(viewModel.name == expectedVehicle.name)
        #expect(viewModel.category == expectedVehicle.category)
        #expect(viewModel.id != nil)
        #expect(viewModel.formattedPrice == "99,99 kr")
    }

    @Test
    func testFetchVehicleFailure() async {
        setUp()
        let expectedError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        mockService.error = expectedError
        await viewModel.fetchVehicle()
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.vehicle == nil)
        #expect(viewModel.errorMessage == "Failed to fetch vehicle details: Something went wrong")
    }

    @Test
    func testComputedPropertiesWithNilVehicle() {
        setUp()
        viewModel.vehicle = nil
        #expect(viewModel.name == nil)
        #expect(viewModel.category == nil)
        #expect(viewModel.id == nil)
        #expect(viewModel.formattedPrice == nil)
    }
}
