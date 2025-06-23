import QRCodeScanner
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scannerView = QRCodeScannerPreviewView()
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scannerView)
        NSLayoutConstraint.activate([
            scannerView.topAnchor.constraint(equalTo: view.topAnchor),
            scannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        do {
            try scannerView.startScanning()
            scannerView.onCodeScanned = { code in
                print("Scanned QR Code: \(code)")
            }
        } catch {
            print("Failed to start scanning: \(error)")
        }
    }
}
