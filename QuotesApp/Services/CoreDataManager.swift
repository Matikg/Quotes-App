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
    
    func saveQuote(/*to book: BookEntity, */text: String, category: String, page: Int, note: String) {
        do {
            let quote = QuoteEntity(context: viewContext)
            let book = getMockBookEntity()
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
    
    // BookEntity Mock for testing purposes
    
    private var mockBookEntity:  BookEntity?
    
    private func getMockBookEntity() -> BookEntity {
        if mockBookEntity == nil {
            let book = BookEntity(context: viewContext)
            book.author = "Mock Author"
            book.title = "Mock Book Title"
            book.coverImage = nil
            mockBookEntity = book
        }
        
        return mockBookEntity!
    }
}
