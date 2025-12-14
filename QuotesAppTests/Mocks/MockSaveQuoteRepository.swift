import Foundation
@testable import QuotesApp

final class MockSaveQuoteRepository: SaveQuoteRepositoryInterface {
    private(set) var selectBookCalledWith: Domain.BookItem?
    private(set) var selectedBook: Domain.BookItem?
    
    func selectBook(_ book: Domain.BookItem) {
        selectBookCalledWith = book
        selectedBook = book
    }
    
    func saveBook(_ book: Domain.BookItem) { }
    
    func resetBook() {
        selectedBook = nil
    }
}
