import DependencyInjection
import UIKit
import Vision

final class ReviewViewModel: ObservableObject {
    @Published var image: UIImage
    @Published var items: [Domain.RecognizedTextItem] = []
    @Published var isLoading = false

    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveScannedQuoteRepository: SaveScannedQuoteRepositoryInterface

    init(image: UIImage) {
        self.image = image
        recognizeText()
    }

    func acceptPhoto() {
        saveScannedQuoteRepository.saveScannedQuote(items.map(\.string).joined(separator: " "))

        navigationRouter.pop()
        navigationRouter.pop()
    }

    func recognizeText(in region: CGRect? = nil) {
        isLoading = true
        Task {
            let results = await performRecognition(on: image, region: region)
            await MainActor.run {
                items = results
                isLoading = false
            }
        }
    }

    private func performRecognition(on image: UIImage, region: CGRect?) async -> [Domain.RecognizedTextItem] {
        guard let cgImage = image.cgImage else { return [] }
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        if let region { request.regionOfInterest = region }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
        return (request.results ?? []).compactMap {
            guard let top = $0.topCandidates(1).first else { return nil }
            return Domain.RecognizedTextItem(string: top.string, boundingBox: $0.boundingBox)
        }
    }
}
