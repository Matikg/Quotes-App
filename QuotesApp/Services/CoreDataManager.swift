//
//  CoreDataManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/10/2024.
//

import Foundation
import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
    private let persistentContainer: NSPersistentContainer
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "QuoteDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        }
        catch {
            return []
        }
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
            book.quotesNumber += 1
            
            try viewContext.save()
        }
        catch {
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
            book.quotesNumber = 0
            mockBookEntity = book
        }
        
        return mockBookEntity!
    }
}
