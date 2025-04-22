//
//  CameraView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/04/2025.
//

import SwiftUI
import VisionKit
import Vision

struct CameraView: UIViewControllerRepresentable {
    private var capturedImage: UIImage?
    private var recognizedText: String?
    
    private var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.text()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isPinchToZoomEnabled: true,
        isGuidanceEnabled: false,
        isHighlightingEnabled: false
    )
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        
        let captureButton = UIButton(type: .system)
        captureButton.setTitle("Zrób zdjęcie", for: .normal)
        captureButton.addTarget(context.coordinator, action: #selector(Coordinator.didTapCapture), for: .touchUpInside)
        scannerViewController.view.addSubview(captureButton)
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: scannerViewController.view.bottomAnchor, constant: -50),
            captureButton.centerXAnchor.constraint(equalTo: scannerViewController.view.centerXAnchor)
        ])
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        
    }
}

extension CameraView {
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        @objc func didTapCapture() {
            Task {
                do {
                    let image = try await parent.scannerViewController.capturePhoto()
                    parent.capturedImage = image
                    print("📸 Zdjęcie zrobione! Rozmiar: \(image.size)")
                    
                    recognizeText(from: image) { recognizedText in
                        DispatchQueue.main.async {
                            self.parent.recognizedText = recognizedText.joined(separator: "\n")
                            print("🧠 Rozpoznany tekst:\n\(self.parent.recognizedText ?? "Brak tekstu")")
                        }
                    }
                } catch {
                    print("Błąd przy robieniu zdjęcia: \(error)")
                }
            }
        }
        
        private func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
            guard let cgImage = image.cgImage else {
                completion([])
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                guard error == nil else {
                    completion([])
                    return
                }
                
                let results = request.results as? [VNRecognizedTextObservation] ?? []
                let strings = results.compactMap { $0.topCandidates(1).first?.string }
                completion(strings)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    completion([])
                }
            }
        }
    }
}
