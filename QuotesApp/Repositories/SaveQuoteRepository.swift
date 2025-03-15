import Foundation
import DependencyInjection

protocol SaveQuoteRepositoryInterface {
    var selectedBook: Domain.BookItem? { get }
    func selectBook(_ book: Domain.BookItem)
    func saveBook(_ book: Domain.BookItem)
}

final class SaveQuoteRepository: SaveQuoteRepositoryInterface {
    @Injected private var coreDataManager: CoreDataManagerProtocol
    
    var selectedBook: Domain.BookItem?
    
    func selectBook(_ book: Domain.BookItem) {
        selectedBook = book
    }
    
    func saveBook(_ book: Domain.BookItem) {
        coreDataManager.saveBook(for: book)
    }
}
