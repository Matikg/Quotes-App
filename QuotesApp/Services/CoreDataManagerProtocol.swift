//
//  CoreDataManagerProtocol.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation

protocol CoreDataManagerProtocol {
    func fetchBooks() -> [BookEntity]
    func saveQuote(/*to book: BookEntity,*/ text: String, category: String, page: Int, note: String)
}
