//
//  LiveScannerView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import SwiftUI
import VisionKit
import Vision
import DependencyInjection

struct LiveScannerView: UIViewControllerRepresentable {
    var capturedImage: UIImage?
    var recognizedItems = [Domain.RecognizedTextItem]()
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
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
            do { try scanner.startScanning() }
            catch { print("Scanner start error:", error) }
        }
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Injected private var navigationRouter: any NavigationRouting
        
        var parent: LiveScannerView
        var scanner: DataScannerViewController?
        
        init(_ parent: LiveScannerView) {
            self.parent = parent
        }
        
        @objc func didTapCapture() {
            guard let scanner else { return }
            
            Task {
                do {
                    let photo = try await scanner.capturePhoto()
                    scanner.stopScanning()
                    
                    let uiImage = uprightImage(photo)
                    let items = await recognizeTextItems(from: uiImage)
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationRouter.push(route: .review(image: uiImage, items: items))
                    }
                } catch {
                    print("Capture error:", error)
                }
            }
        }
        
        func recognizeTextItems(from image: UIImage) async -> [Domain.RecognizedTextItem] {
            guard let cg = image.cgImage else { return [] }
            let req = VNRecognizeTextRequest()
            req.recognitionLevel = .accurate
            req.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cg, options: [:])
            try? handler.perform([req])
            
            let observations = req.results ?? []
            let items = observations.compactMap { obs -> Domain.RecognizedTextItem? in
                guard let top = obs.topCandidates(1).first else { return nil }
                return Domain.RecognizedTextItem(string: top.string, boundingBox: obs.boundingBox)
            }
            return items
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
