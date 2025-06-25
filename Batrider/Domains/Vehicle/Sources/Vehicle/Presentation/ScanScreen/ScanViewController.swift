import QRCodeScanner
import UIKit

public protocol ScanViewControllerDelegate: AnyObject {
    func scanViewController(_ controller: ScanViewController, didScan code: String)
    func scanViewController(_ controller: ScanViewController, didFailWith error: Error)
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
                    self.delegate?.scanViewController(self, didScan: code)
                }
            } catch {
                delegate?.scanViewController(self, didFailWith: error)
            }
        }
    }
}
