import Foundation

/// A custom error type that encapsulates common networking failures.
///
/// Use `NetworkError` to handle and distinguish between various error conditions
/// that can occur during a network request lifecycle.
public enum NetworkError: Error {
    /// Indicates that a URL could not be constructed from the provided components.
    ///
    /// This typically occurs if the `baseURL` or `path` is malformed.
    case invalidURL

    /// Indicates that the server responded with an unexpected or unsupported content type.
    ///
    /// For example, this can occur if the response is not valid JSON when JSON was expected.
    case invalidResponse

    /// Indicates that decoding the server response into a model failed.
    ///
    /// - Parameter error: The underlying `DecodingError` or similar error providing context for the failure.
    case decodingError(Error)

    /// Indicates that the request failed due to an underlying networking error.
    ///
    /// - Parameter error: The original error from `URLSession` or related networking operations (e.g., timeouts, no internet).
    case requestFailed(Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return .networkInvalidURLError
        case .invalidResponse:
            return .networkInvalidResponseError
        case .decodingError:
            return .networkDecodingError
        case .requestFailed:
            return .networkRequestFailedError
        }
    }
}
