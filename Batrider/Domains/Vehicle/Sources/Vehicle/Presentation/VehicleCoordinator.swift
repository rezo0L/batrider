import QRCodeScanner
import SwiftUI
import UIKit

public class VehicleCoordinator: NSObject {
    public let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    public func start() {
        showScanScreen()
    }

    private func showScanScreen() {
        let viewController = ScanViewController()
        viewController.delegate = self
        navigationController.present(viewController, animated: true)
    }

    private func showResultScreen(code: String) {
        let vehicleView = VehicleView(vehicleId: code)
        let hostingController = UIHostingController(rootView: vehicleView)
        hostingController.view.backgroundColor = .clear
        hostingController.modalPresentationStyle = .overCurrentContext
        hostingController.modalTransitionStyle = .crossDissolve
        navigationController.present(hostingController, animated: true)
    }
}

extension VehicleCoordinator: ScanViewControllerDelegate {
    public func scanViewController(_ viewController: ScanViewController, didScan code: String) {
        viewController.dismiss(animated: true)
        showResultScreen(code: code)
    }

    public func scanViewController(_ viewController: ScanViewController, didFailWith error: QRCodeScannerError) {
        // Handle the error
        print("Scanning failed with error: \(error)")
    }
}

