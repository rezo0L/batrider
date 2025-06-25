import Foundation

/// An error type representing failures that can occur when using a QR code scanner.
public enum QRCodeScannerError: Error {
    /// Indicates that the camera permission was not granted.
    case notAuthorized

    /// Indicates that the device's camera is not available for use.
    case cameraUnavailable
}

extension QRCodeScannerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return .cameraNotAuthorizedError
        case .cameraUnavailable:
            return .cameraUnavailableError
        }
    }
}
