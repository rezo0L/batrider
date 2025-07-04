import Foundation

extension String {
    static let scanInstruction = String(localized: "Scan the QR code on the handlebar of the vehicle.", comment: "Instruction for scanning QR code")
    static let flashOff = String(localized: "Flash off", comment: "Torch button off state")
    static let flashOn = String(localized: "Flash on", comment: "Torch button on state")
    static let torchErrorTitle = String(localized: "Torch Error", comment: "Title for torch error alert")
    static let okButton = String(localized: "OK", comment: "OK button title for alerts")
    static let cameraNotAuthorizedError = String(localized: "Camera access is not authorized. Please enable camera permissions in Settings.", comment: "Error message when camera permission is denied for QR code scanner")
    static let cameraUnavailableError = String(localized: "Camera is unavailable on this device.", comment: "Error message when camera is not available for QR code scanner")
}
