import Foundation
@testable import QuotesApp

final class MockSaveQuoteRepository: SaveQuoteRepositoryInterface {
    private(set) var selectBookCalledWith: Domain.BookItem? = nil
    
    private(set) var _selectedBook: Domain.BookItem? = nil
    var selectedBook: Domain.BookItem? { _selectedBook }
    
    func selectBook(_ book: Domain.BookItem) {
        selectBookCalledWith = book
        _selectedBook = book
    }
    
    func saveBook(_ book: Domain.BookItem) { }
    
    func resetBook() {
        _selectedBook = nil
    }
}
