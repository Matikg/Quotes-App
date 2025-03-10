//
//  CoreDataManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation
import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
    private enum Configuration {
        static let containerName = "QuoteDataModel"
    }
    
    private let persistentContainer: NSPersistentContainer
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer = .init(name: Configuration.containerName)) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, _ in }
    }
    
    func fetchBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        let fetched = try? viewContext.fetch(request)
        return fetched ?? []
    }
    
    func saveQuote(to book: BookEntity, text: String, category: String, page: Int, note: String) {
        do {
            let quote = QuoteEntity(context: viewContext)
            quote.id = UUID()
            quote.date = .now
            quote.book = book
            quote.text = text
            quote.category = category
            quote.page = Int64(page)
            quote.note = note
            
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func deleteBook() {
        print("Deleted")
    }
    
    func saveBook(for book: Domain.BookItem) {
        do {
            let bookEntity = BookEntity(context: viewContext)
            bookEntity.id = book.id
            bookEntity.author = book.author
            bookEntity.title = book.title
            bookEntity.coverImage = book.coverImageData
            
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity? {
        let request = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", domainBook.id as CVarArg)
        
        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            return nil
        }
    }
    
    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity] {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "book.id == %@", selectedBook.id as CVarArg)
        
        do {
            let quotes = try viewContext.fetch(request)
            return quotes
        } catch {
            return []
        }
    }
}
