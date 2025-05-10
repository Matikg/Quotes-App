//
//  CoreDataManagerProtocol.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation

protocol CoreDataManagerInterface {
    func fetchBooks() -> [BookEntity]
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity?
    func saveQuote(to book: BookEntity, text: String, category: String, page: Int, note: String, quoteId: UUID?)
    func deleteBook(book: Domain.BookItem)
    func deleteQuote(quote: Domain.QuoteItem)
    func saveBook(for book: Domain.BookItem)
    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity]
    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity?
}
