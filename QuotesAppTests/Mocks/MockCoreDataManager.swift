import Foundation
@testable import QuotesApp

final class MockCoreDataManager: CoreDataManagerInterface {
    private(set) var fetchBooksCalled = false
    
    var booksToReturn: [BookEntity] = []
    
    func fetchBooks() -> [BookEntity] {
        fetchBooksCalled = true
        return booksToReturn
    }
    
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity? { nil }
    func saveQuote(
        to book: BookEntity,
        text: String,
        category: String,
        page: Int,
        note: String,
        quoteId: UUID?
    ) { }
    func deleteBook(book: Domain.BookItem) { }
    func deleteQuote(quote: Domain.QuoteItem) { }
    func saveBook(for book: Domain.BookItem) { }
    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity] { [] }
    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity? { nil }
    func fetchAllQuotes() -> [QuoteEntity] { [] }
}
