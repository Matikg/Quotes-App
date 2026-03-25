import Combine
import Foundation
@testable import QuotesApp

final class MockSaveQuoteRepository: SaveQuoteRepositoryInterface {
    private(set) var selectBookCalledWith: Domain.BookItem?
    private(set) var selectedBook: Domain.BookItem?
    var shouldReturnToQuoteEditAfterBookSave = false
    var selectedBookPublisher: AnyPublisher<Domain.BookItem?, Never> {
        Just(selectedBook).eraseToAnyPublisher()
    }

    func selectBook(_ book: Domain.BookItem) {
        selectBookCalledWith = book
        selectedBook = book
    }

    func saveBook(_: Domain.BookItem) {}

    func setShouldReturnToQuoteEditAfterBookSave(_ shouldReturn: Bool) {
        shouldReturnToQuoteEditAfterBookSave = shouldReturn
    }

    func resetBook() {
        selectedBook = nil
        shouldReturnToQuoteEditAfterBookSave = false
    }
}
