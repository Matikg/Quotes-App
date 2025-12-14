import DependencyInjection
import SwiftUI
import Vision
import VisionKit

struct LiveScannerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: false
        )

        scanner.delegate = context.coordinator
        context.coordinator.scanner = scanner

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 32
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 64).isActive = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.didTapCapture),
            for: .touchUpInside
        )

        scanner.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: scanner.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: scanner.view.centerXAnchor)
        ])

        DispatchQueue.main.async {
            try? scanner.startScanning()
        }

        return scanner
    }

    func updateUIViewController(_: DataScannerViewController, context _: Context) {}

    @MainActor
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Injected private var navigationRouter: any NavigationRouting
        @Injected private var crashlyticsManager: CrashlyticsManagerInterface

        var parent: LiveScannerView
        weak var scanner: DataScannerViewController?
        private var isCapturingPhoto = false

        init(_ parent: LiveScannerView) {
            self.parent = parent
        }

        @objc func didTapCapture() {
            guard !isCapturingPhoto, let scanner else { return }
            isCapturingPhoto = true

            Task { @MainActor in
                let start = CFAbsoluteTimeGetCurrent()

                defer {
                    isCapturingPhoto = false
                    _ = CFAbsoluteTimeGetCurrent() - start
                }

                do {
                    if scanner.isScanning {
                        scanner.stopScanning()
                    }

                    let photo = try await scanner.capturePhoto()
                    _ = CFAbsoluteTimeGetCurrent()

                    // Push review screen
                    navigationRouter.push(route: .review(image: photo))
                    _ = CFAbsoluteTimeGetCurrent()

                } catch {
                    crashlyticsManager.record(error)
                }
            }
        }
    }
}
