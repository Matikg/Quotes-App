import Foundation

protocol CoreDataManagerInterface {
    func fetchBooks() -> [BookEntity]
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity?
    func deleteBook(book: Domain.BookItem)
    func deleteQuote(quote: Domain.QuoteItem)
    func saveBook(for book: Domain.BookItem)
    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity]
    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity?
    func fetchAllQuotes() -> [QuoteEntity]
    func fetchCategories() -> [String]
    func fetchBooksCount() -> Int
    func fetchQuotesCount() -> Int
    func saveQuote(
        toBookId bookId: UUID,
        text: String,
        category: String,
        page: Int,
        note: String,
        quoteId: UUID?
    )
}
