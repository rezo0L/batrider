import AVFoundation

class QRCodeScannerController: NSObject {
    var onCodeScanned: ((String) -> Void)?

    private lazy var captureSession = AVCaptureSession()

    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    private var isScanning = false

    func requestCameraAccess() async throws {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return
        case .notDetermined:
            if await !AVCaptureDevice.requestAccess(for: .video) {
                throw QRCodeScannerError.notAuthorized
            }
        default:
            throw QRCodeScannerError.notAuthorized
        }
    }

    func startScanning() throws {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            throw QRCodeScannerError.notAuthorized
        }

        guard !isScanning else { return }
        isScanning = true

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            throw QRCodeScannerError.cameraUnavailable
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            throw QRCodeScannerError.cameraUnavailable
        }

        if captureSession.inputs.isEmpty {
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                throw QRCodeScannerError.cameraUnavailable
            }
        }

        if captureSession.outputs.isEmpty {
            let metadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                throw QRCodeScannerError.cameraUnavailable
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    func toggleTorch() throws -> Bool {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return false }

        try device.lockForConfiguration()

        let isTorchOn: Bool
        if device.torchMode == .on {
            device.torchMode = .off
            isTorchOn = false
        } else {
            try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            isTorchOn = true
        }

        device.unlockForConfiguration()
        return isTorchOn
    }

    func stopScanning() {
        isScanning = false
        captureSession.stopRunning()
    }
}

extension QRCodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from _: AVCaptureConnection)
    {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }
        onCodeScanned?(stringValue)
        stopScanning()
    }
}
