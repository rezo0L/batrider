import Foundation
import NetworkClient

// Defines the endpoints for the Vehicle API
enum VehicleEndpoint {
    case fetch(identifier: String)
}

extension VehicleEndpoint: Endpoint {
    var baseURL: URL {
        guard let url = URL(string: "https://ios-assignment.glitch.me") else {
            preconditionFailure("Invalid base URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .fetch:
            return "vehicle"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        }
    }

    var parameters: [String: String]? {
        switch self {
        case let .fetch(code):
            return ["qrcode": code]
        }
    }
}
