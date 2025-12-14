import Foundation

protocol SaveScannedQuoteRepositoryInterface {
    var scannedQuote: String? { get }

    func saveScannedQuote(_ scannedQuote: String)
    func resetScannedQuote()
}

final class SaveScannedQuoteRepository: SaveScannedQuoteRepositoryInterface {
    var scannedQuote: String?

    func saveScannedQuote(_ scannedQuote: String) {
        self.scannedQuote = scannedQuote
    }

    func resetScannedQuote() {
        scannedQuote = nil
    }
}
