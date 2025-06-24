import Foundation

/// A concrete implementation of `NetworkClient` that uses `URLSession` for performing HTTP requests.
///
/// This client handles request construction, network execution, error mapping,
/// optional request logging, and JSON decoding.
public class URLSessionClient: NetworkClient {

    /// The URL session used to perform network requests.
    private let session: URLSession

    /// The JSON decoder used to decode response data.
    private let decoder: JSONDecoder

    /// Creates a new instance of `URLSessionClient`.
    ///
    /// - Parameters:
    ///   - session: The `URLSession` to use. Defaults to `.shared`.
    ///   - decoder: The `JSONDecoder` to use for decoding responses. Defaults to a new instance.
    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    /// Sends an HTTP request using the given `Endpoint` and decodes the response into a `Decodable` type.
    ///
    /// - Parameter endpoint: The endpoint describing the request configuration.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: `NetworkError.invalidURL`, `NetworkError.invalidResponse`, `NetworkError.requestFailed`, or `NetworkError.decodingError`.
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }

        if let parameters = endpoint.parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        #if DEBUG
        debugPrint("➡️ Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            debugPrint("Headers: \(headers)")
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            debugPrint("Body: \(bodyString)")
        }
        #endif

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        #if DEBUG
        debugPrint("⬅️ Response (\(httpResponse.statusCode)): \(String(data: data, encoding: .utf8) ?? "<non-UTF8 data>")")
        #endif

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
