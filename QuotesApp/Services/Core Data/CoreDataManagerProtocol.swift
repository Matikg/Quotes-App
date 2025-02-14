//
//  CoreDataManagerProtocol.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation

protocol CoreDataManagerProtocol {
    func fetchBooks() -> [BookEntity]
    func fetchBookEntity(for domainBook: Domain.Book) -> BookEntity?
    func saveQuote(to book: BookEntity, text: String, category: String, page: Int, note: String)
    func deleteBook()
    func saveBook(for book: Domain.Book)
}
