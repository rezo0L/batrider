import UIKit

/// A view that provides QR code scanning functionality using AVFoundation.
/// This view can be used to integrate QR code scanning capabilities into any UIKit-based application.
public class QRCodeScannerPreviewView: UIView, QRCodeScanner {

    public func requestCameraAccess() async throws {
        try await scanner.requestCameraAccess()
    }

    public func startScanning() throws {
        try scanner.startScanning()
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
        imageView.image = UIImage(systemName: "qrcode.viewfinder", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light))
        imageView.tintColor = .white
        return imageView
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Scan the QR code on the handlebar of the vehicle."
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var torchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "flashlight.off.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        config.imagePlacement = .top
        config.imagePadding = 12

        var title = AttributedString("Flash off")
        title.font = .systemFont(ofSize: 12, weight: .medium)
        config.attributedTitle = title

        config.baseForegroundColor = .white
        button.configuration = config

        button.addTarget(self, action: #selector(didTapTorchButton), for: .touchUpInside)
        return button
    }()

    private lazy var guideFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 24
        return view
    }()

    public override init(frame: CGRect) {
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
        addSubview(guideFrameView)
        addSubview(qrCodeIconView)
        addSubview(instructionLabel)
        addSubview(closeButton)
        addSubview(torchButton)

        let guideFrameSide: CGFloat = 250

        NSLayoutConstraint.activate([
            guideFrameView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            guideFrameView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            guideFrameView.widthAnchor.constraint(equalToConstant: guideFrameSide),
            guideFrameView.heightAnchor.constraint(equalToConstant: guideFrameSide),

            qrCodeIconView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            qrCodeIconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            instructionLabel.topAnchor.constraint(equalTo: qrCodeIconView.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            instructionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),

            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            torchButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            torchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }

    public override func layoutSubviews() {
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
                newConfig?.image = UIImage(systemName: "flashlight.on.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
                newTitle = AttributedString("Flash on")
            } else {
                newConfig?.image = UIImage(systemName: "flashlight.off.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
                newTitle = AttributedString("Flash off")
            }

            newTitle.font = .systemFont(ofSize: 12, weight: .medium)
            newConfig?.attributedTitle = newTitle
            torchButton.configuration = newConfig

        } catch {
            // unhandled
        }
    }
}
