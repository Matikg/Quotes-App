import SwiftUI
import VisionKit
import Vision
import UIKit

struct RecognizedTextItem: Identifiable {
    let id = UUID()
    let string: String
    let boundingBox: CGRect
}

struct CameraScannerView: View {
    @State private var isScanning = true
    @State private var capturedImage: UIImage?
    @State private var recognizedItems: [RecognizedTextItem] = []
    
    var body: some View {
        ZStack {
            if isScanning {
                LiveScannerView(capturedImage: $capturedImage,
                                recognizedItems: $recognizedItems,
                                isScanning: $isScanning)
                .edgesIgnoringSafeArea(.all)
            } else if let image = capturedImage {
                ReviewView(image: image,
                           items: recognizedItems,
                           onRetake: {
                    recognizedItems = []
                    capturedImage = nil
                    isScanning = true
                })
            }
        }
    }
}

struct LiveScannerView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var recognizedItems: [RecognizedTextItem]
    @Binding var isScanning: Bool
    
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
                        self?.parent.capturedImage = uiImage
                        self?.parent.recognizedItems = items
                        self?.parent.isScanning = false
                    }
                } catch {
                    print("Capture error:", error)
                }
            }
        }
        
        func recognizeTextItems(from image: UIImage) async -> [RecognizedTextItem] {
            guard let cg = image.cgImage else { return [] }
            let req = VNRecognizeTextRequest()
            req.recognitionLevel = .accurate
            req.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cg, options: [:])
            try? handler.perform([req])
            
            let observations = req.results ?? []
            let items = observations.compactMap { obs -> RecognizedTextItem? in
                guard let top = obs.topCandidates(1).first else { return nil }
                return RecognizedTextItem(string: top.string, boundingBox: obs.boundingBox)
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

struct ReviewView: View {
    let image: UIImage
    let items: [RecognizedTextItem]
    @State private var selectedText = ""
    @State private var showCopiedAlert = false
    var onRetake: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let container = geo.size
                let imgSize = image.size
                let scale = min(
                    container.width / imgSize.width,
                    container.height / imgSize.height
                )
                let displayS = CGSize(
                    width: imgSize.width * scale,
                    height: imgSize.height * scale
                )
                let xOffset = (container.width - displayS.width) / 2
                let yOffset = (container.height - displayS.height) / 2
                
                ZStack(alignment: .topLeading) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: displayS.width, height: displayS.height)
                    
                    ForEach(items) { item in
                        let box = item.boundingBox
                        let x = box.minX * displayS.width
                        let y = (1 - box.maxY) * displayS.height
                        let width = box.width  * displayS.width
                        let height = box.height * displayS.height
                        
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: width, height: height)
                            .offset(x: x, y: y)
                    }
                }
                .offset(x: xOffset, y: yOffset)
            }
            .frame(height: 400)
            
            Divider()
            
            ScrollView {
                Text(items.map(\.string).joined(separator: " "))
                    .padding()
                    .textSelection(.enabled)
            }
            .layoutPriority(1)
            
            Divider()
            
            HStack {
                Button("Retake", action: onRetake).padding()
                Spacer()
                Button("Done", action: { /* dismiss */ }).padding()
            }
        }
        .alert(isPresented: $showCopiedAlert) {
            Alert(
                title: Text("Copied"),
                message: Text("\(selectedText)"),
                dismissButton: .default(Text("OK")) {
                    UIPasteboard.general.string = selectedText
                }
            )
        }
    }
}




//struct CameraView: UIViewControllerRepresentable {
//    private var capturedImage: UIImage?
//    private var recognizedText: String?
//
//    private var scannerViewController: DataScannerViewController = DataScannerViewController(
//        recognizedDataTypes: [.text()],
//        qualityLevel: .accurate,
//        recognizesMultipleItems: false,
//        isHighFrameRateTrackingEnabled: false,
//        isPinchToZoomEnabled: true,
//        isGuidanceEnabled: false,
//        isHighlightingEnabled: false
//    )
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> DataScannerViewController {
//        scannerViewController.delegate = context.coordinator
//
//        let captureButton = UIButton(type: .system)
//        captureButton.setTitle("Zrób zdjęcie", for: .normal)
//        captureButton.addTarget(context.coordinator, action: #selector(Coordinator.didTapCapture), for: .touchUpInside)
//        scannerViewController.view.addSubview(captureButton)
//
//        captureButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            captureButton.bottomAnchor.constraint(equalTo: scannerViewController.view.bottomAnchor, constant: -50),
//            captureButton.centerXAnchor.constraint(equalTo: scannerViewController.view.centerXAnchor)
//        ])
//
//        DispatchQueue.main.async {
//            do {
//                try scannerViewController.startScanning()
//            } catch {
//                print("❗️Nie udało się wystartować skanowania: \(error)")
//            }
//        }
//        return scannerViewController
//    }
//
//    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
//
//    }
//}
//
//extension CameraView {
//    class Coordinator: NSObject, DataScannerViewControllerDelegate {
//        private var parent: CameraView
//
//        init(_ parent: CameraView) {
//            self.parent = parent
//        }
//
//        @objc func didTapCapture() {
//            Task {
//                do {
//                    let image = try await parent.scannerViewController.capturePhoto()
//                    parent.capturedImage = image
//                    print("📸 Zdjęcie zrobione! Rozmiar: \(image.size)")
//
//                    recognizeText(from: image) { recognizedText in
//                        DispatchQueue.main.async {
//                            self.parent.recognizedText = recognizedText.joined(separator: "\n")
//                            print("🧠 Rozpoznany tekst:\n\(self.parent.recognizedText ?? "Brak tekstu")")
//                        }
//                    }
//                } catch {
//                    print("Błąd przy robieniu zdjęcia: \(error)")
//                }
//            }
//        }
//
//        private func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
//            guard let cgImage = image.cgImage else {
//                completion([])
//                return
//            }
//
//            let request = VNRecognizeTextRequest { request, error in
//                guard error == nil else {
//                    completion([])
//                    return
//                }
//
//                let results = request.results as? [VNRecognizedTextObservation] ?? []
//                let strings = results.compactMap { $0.topCandidates(1).first?.string }
//                completion(strings)
//            }
//
//            request.recognitionLevel = .accurate
//            request.usesLanguageCorrection = true
//
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            DispatchQueue.global(qos: .userInitiated).async {
//                do {
//                    try handler.perform([request])
//                } catch {
//                    completion([])
//                }
//            }
//        }
//    }
//}
