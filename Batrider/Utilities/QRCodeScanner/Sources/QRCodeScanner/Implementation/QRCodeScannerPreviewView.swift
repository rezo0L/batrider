import AVFoundation
import UIKit

/// A view that provides QR code scanning functionality using AVFoundation.
/// This view can be used to integrate QR code scanning capabilities into any UIKit-based application.
public class QRCodeScannerPreviewView: UIView, QRCodeScanner {

    public var onCodeScanned: ((String) -> Void)?

    private lazy var captureSession = AVCaptureSession()

    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    private var isScanning = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupPreviewLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPreviewLayer()
    }

    private func setupPreviewLayer() {
        layer.addSublayer(previewLayer)
        previewLayer.frame = bounds
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }

    public func startScanning() throws {
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

    public func stopScanning() {
        isScanning = false
        captureSession.stopRunning()
    }
}

extension QRCodeScannerPreviewView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }
        onCodeScanned?(stringValue)
        stopScanning()
    }
}
