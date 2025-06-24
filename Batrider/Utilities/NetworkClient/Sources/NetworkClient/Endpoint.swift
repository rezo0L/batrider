import Foundation

/// Represents the HTTP methods used in network requests.
///
/// These methods indicate the desired action to be performed for a given resource.
public enum HTTPMethod: String {
    /// The `GET` method is used to retrieve data from a server.
    case get = "GET"

    /// The `POST` method is used to send data to a server to create a new resource.
    case post = "POST"

    /// The `PUT` method is used to update an existing resource on the server.
    case put = "PUT"

    /// The `DELETE` method is used to remove a resource from the server.
    case delete = "DELETE"
}

/// Represents an endpoint for network requests.
///
/// Types conforming to this protocol define the necessary components of an HTTP request,
/// such as the URL, path, HTTP method, headers, and request body.
public protocol Endpoint {

    /// The base URL of the endpoint (e.g., `https://api.example.com`).
    var baseURL: URL { get }

    /// The path to be appended to the base URL (e.g., `/users/123`).
    var path: String { get }

    /// The HTTP method to be used for the request.
    var method: HTTPMethod { get }

    /// The HTTP headers to include in the request. Defaults to `nil`.
    var headers: [String: String]? { get }

    /// The query parameters to include in the request URL. Defaults to `nil`.
    var parameters: [String: String]? { get }

    /// The body data to include in the request. Defaults to `nil`.
    var body: Data? { get }
}

public extension Endpoint {
    /// Default implementation returns `nil`, indicating no headers.
    var headers: [String: String]? { nil }

    /// Default implementation returns `nil`, indicating no query parameters.
    var parameters: [String: String]? { nil }

    /// Default implementation returns `nil`, indicating no body data.
    var body: Data? { nil }
}
