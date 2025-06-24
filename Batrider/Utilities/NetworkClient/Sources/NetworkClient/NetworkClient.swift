/// A protocol that defines a generic interface for making network requests.
///
/// Conforming types are responsible for implementing a method to perform asynchronous
/// network requests and decode the response into a specified `Decodable` type.
public protocol NetworkClient {

    /// Sends an asynchronous network request to the specified endpoint and decodes the response.
    ///
    /// - Parameter endpoint: An `Endpoint` instance that defines the request details such as URL, HTTP method, headers, and parameters.
    /// - Returns: A decoded object of type `T` that conforms to `Decodable`.
    /// - Throws: An error if the network request fails or if decoding the response fails.
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}
