//
//  CoreDataManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation
import CoreData
import DependencyInjection

final class CoreDataManager: CoreDataManagerInterface {
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface
    
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
        
        do {
            return try viewContext.fetch(request)
        } catch {
            crashlyticsManager.record(error)
            return []
        }
    }
    
    func saveQuote(to book: BookEntity, text: String, category: String, page: Int, note: String, quoteId: UUID? = nil) {
        do {
            let quote: QuoteEntity
            if let id = quoteId {
                let request = QuoteEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                if let existingQuote = try viewContext.fetch(request).first {
                    quote = existingQuote
                } else {
                    quote = QuoteEntity(context: viewContext)
                    quote.id = id
                    quote.date = Date()
                }
            } else {
                quote = QuoteEntity(context: viewContext)
                quote.id = UUID()
                quote.date = Date()
            }
            
            if let currentBook = quote.book, currentBook.objectID != book.objectID {
                currentBook.removeFromQuotes(quote)
            }
            
            quote.book = book
            quote.text = text
            quote.category = category
            quote.page = Int64(page)
            quote.note = note
            
            try viewContext.save()
        } catch {
            viewContext.rollback()
            crashlyticsManager.record(error)
        }
    }
    
    func deleteQuote(quote: Domain.QuoteItem) {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quote.id as CVarArg)
        
        do {
            if let quoteEntity = try viewContext.fetch(request).first {
                viewContext.delete(quoteEntity)
                try viewContext.save()
            }
        } catch {
            viewContext.rollback()
            crashlyticsManager.record(error)
        }
    }
    
    func deleteBook(book: Domain.BookItem) {
        let request = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
        
        do {
            if let bookEntity = try viewContext.fetch(request).first {
                viewContext.delete(bookEntity)
                try viewContext.save()
            }
        } catch {
            viewContext.rollback()
            crashlyticsManager.record(error)
        }
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
            crashlyticsManager.record(error)
        }
    }
    
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity? {
        let request = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", domainBook.id as CVarArg)
        
        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            crashlyticsManager.record(error)
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
            crashlyticsManager.record(error)
            return []
        }
    }
    
    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity? {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quote.id as CVarArg)
        do {
            let quotes = try viewContext.fetch(request)
            guard let quoteEntity = quotes.first else { return nil }
            
            return quoteEntity.book
        } catch {
            crashlyticsManager.record(error)
            return nil
        }
    }
}
