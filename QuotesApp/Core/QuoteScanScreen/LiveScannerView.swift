import SwiftUI
import VisionKit
import Vision
import DependencyInjection

struct LiveScannerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: false
        )
        scanner.delegate = context.coordinator
        context.coordinator.scanner = scanner
        
        // Capture button
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
        
        //TODO: ViewModel tutaj
        
        DispatchQueue.main.async {
            do { try scanner.startScanning() }
            catch { print("Scanner start error:", error) }
        }
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Injected private var navigationRouter: any NavigationRouting
        @Injected private var crashlyticsManager: CrashlyticsManagerInterface
        
        var parent: LiveScannerView
        var scanner: DataScannerViewController?
        private var isCapturingPhoto = false
        
        init(_ parent: LiveScannerView) {
            self.parent = parent
        }
        
        @objc func didTapCapture() {
            guard !isCapturingPhoto, let scanner else { return }
            isCapturingPhoto = true
            
            Task {
                defer {
                    DispatchQueue.main.async { [weak self] in
                        self?.isCapturingPhoto = false
                    }
                }
                
                do {
                    let photo = try await scanner.capturePhoto()
                    scanner.stopScanning()
                    let uiImage = uprightImage(photo)
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationRouter.push(route: .review(image: uiImage))
                    }
                } catch {
                    crashlyticsManager.record(error)
                }
            }
        }
        
        private func uprightImage(_ image: UIImage) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let normalized = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return normalized
        }
    }
}
