import DependencyInjection
import UIKit
import Vision

@MainActor
final class ReviewViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveScannedQuoteRepository: SaveScannedQuoteRepositoryInterface

    @Published private(set) var image: UIImage
    @Published private(set) var items: [Domain.RecognizedTextItem] = []
    @Published private(set) var isLoading = false

    init(image: UIImage) {
        self.image = image
    }

    func acceptPhoto() {
        saveScannedQuoteRepository.saveScannedQuote(items.map(\.string).joined(separator: " "))

        navigationRouter.pop()
        navigationRouter.pop()
    }

    func recognizeText(in region: CGRect? = nil) async {
        isLoading = true
        defer { isLoading = false }

        items = await performRecognition(on: image, region: region)
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
