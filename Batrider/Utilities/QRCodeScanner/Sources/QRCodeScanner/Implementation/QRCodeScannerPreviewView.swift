import DesignSystem
import UIKit

/// A view that provides QR code scanning functionality using AVFoundation.
/// This view can be used to integrate QR code scanning capabilities into any UIKit-based application.
public class QRCodeScannerPreviewView: UIView, QRCodeScanner {
    public func requestCameraAccess() async throws {
        try await scanner.requestCameraAccess()
    }

    public func startScanning() throws {
        try scanner.startScanning()
        backgroundColor = .clear
    }

    public var onCodeScanned: ((String) -> Void)? {
        get { scanner.onCodeScanned }
        set { scanner.onCodeScanned = newValue }
    }

    public var onCloseButtonTapped: (() -> Void)?

    public func stopScanning() {
        scanner.stopScanning()
    }

    private let scanner = QRCodeScannerController()

    private lazy var qrCodeIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: DesignSystem.Icon.scan, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light))
        imageView.tintColor = .init(DesignSystem.Color.button)
        return imageView
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystem.Font.caption
        label.textColor = .init(DesignSystem.Color.button)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = .scanInstruction
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: DesignSystem.Icon.close), for: .normal)
        button.tintColor = .init(DesignSystem.Color.button)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var torchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: DesignSystem.Icon.torchOff, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        config.imagePadding = DesignSystem.Layout.defaultPadding
        var title = AttributedString(.flashOff)
        title.font = DesignSystem.Font.caption
        config.attributedTitle = title
        config.baseForegroundColor = .init(DesignSystem.Color.button)
        button.configuration = config

        button.addTarget(self, action: #selector(didTapTorchButton), for: .touchUpInside)
        return button
    }()

    private lazy var guideFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = DesignSystem.Color.button.cgColor
        view.layer.borderWidth = DesignSystem.Layout.borderWidth
        view.layer.cornerRadius = DesignSystem.Layout.cornerRadius
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupPreviewLayer()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPreviewLayer()
        setupUI()
    }

    private func setupPreviewLayer() {
        layer.addSublayer(scanner.previewLayer)
    }

    private func setupUI() {
        backgroundColor = .init(DesignSystem.Color.background)

        addSubview(guideFrameView)
        addSubview(qrCodeIconView)
        addSubview(instructionLabel)
        addSubview(closeButton)
        addSubview(torchButton)

        NSLayoutConstraint.activate([
            guideFrameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            guideFrameView.centerYAnchor.constraint(equalTo: centerYAnchor),
            guideFrameView.widthAnchor.constraint(equalToConstant: 250),
            guideFrameView.heightAnchor.constraint(equalToConstant: 250),

            qrCodeIconView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DesignSystem.Layout.doubleVerticalSpacing),
            qrCodeIconView.centerXAnchor.constraint(equalTo: centerXAnchor),

            instructionLabel.topAnchor.constraint(equalTo: qrCodeIconView.bottomAnchor, constant: DesignSystem.Layout.defaultPadding),
            instructionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DesignSystem.Layout.largePadding),
            instructionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -DesignSystem.Layout.largePadding),

            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DesignSystem.Layout.defaultPadding),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -DesignSystem.Layout.defaultPadding),

            torchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -DesignSystem.Layout.doubleVerticalSpacing),
            torchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        scanner.previewLayer.frame = bounds
    }

    @objc private func didTapCloseButton() {
        onCloseButtonTapped?()
    }

    @objc private func didTapTorchButton() {
        do {
            let isTorchOn = try scanner.toggleTorch()
            var newConfig = torchButton.configuration
            var newTitle: AttributedString

            if isTorchOn {
                newConfig?.image = UIImage(systemName: DesignSystem.Icon.torchOn, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
                newTitle = AttributedString(.flashOn)
            } else {
                newConfig?.image = UIImage(systemName: DesignSystem.Icon.torchOff, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
                newTitle = AttributedString(.flashOff)
            }

            newTitle.font = DesignSystem.Font.caption
            newConfig?.attributedTitle = newTitle
            torchButton.configuration = newConfig

        } catch {
            if let viewController = findViewController() {
                let alert = UIAlertController(title: .torchErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: .okButton, style: .default))
                viewController.present(alert, animated: true)
            }
        }
    }

    // Helper to find the nearest view controller
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController {
                return vc
            }
            responder = r.next
        }
        return nil
    }
}
