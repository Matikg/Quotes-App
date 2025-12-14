import Foundation
@testable import QuotesApp

final class MockCoreDataManager: CoreDataManagerInterface {
    private(set) var fetchBooksCalled = false
    private(set) var fetchBooksCallsCount = 0

    var booksToReturn: [BookEntity] = []

    func fetchBooks() -> [BookEntity] {
        fetchBooksCalled = true
        fetchBooksCallsCount += 1
        return booksToReturn
    }

    func fetchBookEntity(for _: Domain.BookItem) -> BookEntity? { nil }
    func saveQuote(
        to _: BookEntity,
        text _: String,
        category _: String,
        page _: Int,
        note _: String,
        quoteId _: UUID?
    ) {}
    func deleteBook(book _: Domain.BookItem) {}
    func deleteQuote(quote _: Domain.QuoteItem) {}
    func saveBook(for _: Domain.BookItem) {}
    func fetchQuotes(for _: Domain.BookItem) -> [QuoteEntity] { [] }
    func fetchBook(for _: Domain.QuoteItem) -> BookEntity? { nil }
    func fetchAllQuotes() -> [QuoteEntity] { [] }
    func fetchCategories() -> [String] { [] }
}
