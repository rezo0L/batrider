import Foundation

extension String {
    static let networkInvalidURLError = String(localized: "A valid URL could not be created. Please try again later.", comment: "Error message when URL is invalid in network request")
    static let networkInvalidResponseError = String(localized: "Received an invalid response from the server.", comment: "Error message when server response is invalid or unexpected")
    static let networkDecodingError = String(localized: "Failed to process the server response.", comment: "Error message when decoding server response fails")
    static let networkRequestFailedError = String(localized: "Network request failed. Please check your connection and try again.", comment: "Error message when a network request fails due to connectivity or other issues")
} 