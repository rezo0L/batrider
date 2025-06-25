/// A protocol that defines a reusable QR code scanner using the device's camera.
/// Conforming types can start and stop scanning, and handle scanned QR code data.
public protocol QRCodeScanner: AnyObject {
    /// Requests permission to access the device's camera.
    /// - Throws: An error if the camera access is denied or unavailable.
    func requestCameraAccess() async throws

    /// Starts the QR code scanning process.
    /// This method sets up the camera and begins scanning for QR codes.
    /// - Throws: An error if the camera cannot be accessed or if scanning fails to start.
    func startScanning() throws

    /// A closure that is called when a QR code is successfully scanned.
    /// - Parameter code: The decoded string value from the scanned QR code.
    var onCodeScanned: ((String) -> Void)? { get set }

    /// Stops the QR code scanning process.
    /// This method releases the camera and stops scanning for QR codes.
    func stopScanning()
}
