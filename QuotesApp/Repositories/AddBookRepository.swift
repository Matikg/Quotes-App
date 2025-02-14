import Foundation
import DependencyInjection

protocol AddBookRepositoryInterface {
    var selectedBook: Domain.Book? { get }
    func selectBook(_ book: Domain.Book)
    func saveBook(_ book: Domain.Book)
}

final class AddBookRepository: AddBookRepositoryInterface {
    @Injected private var coreDataManager: CoreDataManagerProtocol
    
    var selectedBook: Domain.Book?
    
    func selectBook(_ book: Domain.Book) {
        selectedBook = book
    }
    
    func saveBook(_ book: Domain.Book) {
        coreDataManager.saveBook(for: book)
    }
}
