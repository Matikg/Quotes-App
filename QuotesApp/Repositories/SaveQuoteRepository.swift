import Combine
import DependencyInjection
import Foundation

protocol SaveQuoteRepositoryInterface {
    var selectedBook: Domain.BookItem? { get }
    var selectedBookPublisher: AnyPublisher<Domain.BookItem?, Never> { get }
    var shouldReturnToQuoteEditAfterBookSave: Bool { get }

    func selectBook(_ book: Domain.BookItem)
    func saveBook(_ book: Domain.BookItem)
    func setShouldReturnToQuoteEditAfterBookSave(_ shouldReturn: Bool)
    func resetBook()
}

final class SaveQuoteRepository: SaveQuoteRepositoryInterface {
    @Injected private var coreDataManager: CoreDataManagerInterface

    @Published var selectedBook: Domain.BookItem?
    var shouldReturnToQuoteEditAfterBookSave = false
    var selectedBookPublisher: AnyPublisher<Domain.BookItem?, Never> {
        $selectedBook.eraseToAnyPublisher()
    }

    func selectBook(_ book: Domain.BookItem) {
        selectedBook = book
    }

    func saveBook(_ book: Domain.BookItem) {
        coreDataManager.saveBook(for: book)
    }

    func setShouldReturnToQuoteEditAfterBookSave(_ shouldReturn: Bool) {
        shouldReturnToQuoteEditAfterBookSave = shouldReturn
    }

    func resetBook() {
        selectedBook = nil
        shouldReturnToQuoteEditAfterBookSave = false
    }
}
