import DependencyInjection
import Foundation

protocol SaveQuoteRepositoryInterface {
    var selectedBook: Domain.BookItem? { get }

    func selectBook(_ book: Domain.BookItem)
    func saveBook(_ book: Domain.BookItem)
    func resetBook()
}

final class SaveQuoteRepository: SaveQuoteRepositoryInterface {
    @Injected private var coreDataManager: CoreDataManagerInterface

    var selectedBook: Domain.BookItem?

    func selectBook(_ book: Domain.BookItem) {
        selectedBook = book
    }

    func saveBook(_ book: Domain.BookItem) {
        coreDataManager.saveBook(for: book)
    }

    func resetBook() {
        selectedBook = nil
    }
}
