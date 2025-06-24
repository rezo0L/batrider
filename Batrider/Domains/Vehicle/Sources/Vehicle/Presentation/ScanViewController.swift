import QRCodeScanner
import UIKit

public protocol ScanViewControllerDelegate: AnyObject {
    func scanViewController(_ controller: ScanViewController, didScan code: String)
    func scanViewController(_ controller: ScanViewController, didFailWith error: QRCodeScannerError)
}

public class ScanViewController: UIViewController {

    public weak var delegate: ScanViewControllerDelegate?

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        let scannerView = QRCodeScannerPreviewView()
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        scannerView.backgroundColor = .black

        scannerView.onCloseButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        scannerView.onCodeScanned = { [weak self] code in
            guard let self else { return }
            delegate?.scanViewController(self, didScan: code)
        }

        view.addSubview(scannerView)
        NSLayoutConstraint.activate([
            scannerView.topAnchor.constraint(equalTo: view.topAnchor),
            scannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        Task { @MainActor in
            do {
                try await scannerView.requestCameraAccess()
                try scannerView.startScanning()
                scannerView.onCodeScanned = { code in
                    print("Scanned QR Code: \(code)")
                }
            } catch {
                print("Failed to start scanning: \(error)")
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.delegate?.scanViewController(self, didScan: "W9MB")
        }
    }
}
