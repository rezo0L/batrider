import QRCodeScanner
import SwiftUI
import UIKit

@MainActor
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
        let viewModel = VehicleViewModel(vehicleId: code)
        let vehicleView = VehicleView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: vehicleView)
        hostingController.view.backgroundColor = .clear
        hostingController.modalPresentationStyle = .overCurrentContext
        hostingController.modalTransitionStyle = .crossDissolve
        navigationController.present(hostingController, animated: true)
    }
}

extension VehicleCoordinator: @preconcurrency ScanViewControllerDelegate {
    public func scanViewController(_ viewController: ScanViewController, didScan code: String) {
        viewController.dismiss(animated: true)
        showResultScreen(code: code)
    }

    public func scanViewController(_ viewController: ScanViewController, didFailWith error: Error) {
        let alert = UIAlertController(title: .scanningFailedTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .okButton, style: .default, handler: { _ in
            viewController.dismiss(animated: true)
        }))
        viewController.present(alert, animated: true)
    }
}

