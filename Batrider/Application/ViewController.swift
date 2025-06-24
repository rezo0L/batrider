import UIKit
import Vehicle

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.setTitle("Vehicle domain", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private var vehicleCoordinator: VehicleCoordinator?

    @objc func didTapButton() {
        guard let navigationController else { return }

        vehicleCoordinator = VehicleCoordinator(navigationController: navigationController)
        vehicleCoordinator?.start()
    }
}
