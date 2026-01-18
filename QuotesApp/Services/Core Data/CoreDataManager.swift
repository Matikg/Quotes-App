import CoreData
import DependencyInjection
import Foundation

final class CoreDataManager: CoreDataManagerInterface {
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface

    private enum Configuration {
        static let containerName = "QuoteDataModel"
    }

    private let persistentContainer: NSPersistentCloudKitContainer

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(persistentContainer: NSPersistentCloudKitContainer = .init(name: Configuration.containerName)) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                self.crashlyticsManager.record(error)
            }
        }
        viewContext.automaticallyMergesChangesFromParent = true
    }

    func fetchBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        var result: [BookEntity] = []
        viewContext.performAndWait {
            do {
                result = try viewContext.fetch(request)
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func saveQuote(
        toBookId bookId: UUID,
        text: String,
        category: String,
        page: Int,
        note: String,
        quoteId: UUID? = nil
    ) {
        viewContext.perform { [weak self] in
            guard let self else { return }
            do {
                let bookRequest = BookEntity.fetchRequest()
                bookRequest.fetchLimit = 1
                bookRequest.predicate = NSPredicate(format: "id == %@", bookId as CVarArg)
                guard let book = try self.viewContext.fetch(bookRequest).first else { return }

                let quote: QuoteEntity
                if let id = quoteId {
                    let request = QuoteEntity.fetchRequest()
                    request.fetchLimit = 1
                    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    if let existing = try self.viewContext.fetch(request).first {
                        quote = existing
                    } else {
                        quote = QuoteEntity(context: self.viewContext)
                        quote.id = id
                        quote.date = Date()
                    }
                } else {
                    quote = QuoteEntity(context: self.viewContext)
                    quote.id = UUID()
                    quote.date = Date()
                }

                quote.book = book
                quote.text = text
                quote.category = category
                quote.page = Int64(page)
                quote.note = note

                try self.viewContext.save()
            } catch {
                self.viewContext.rollback()
                self.crashlyticsManager.record(error)
            }
        }
    }

    func deleteQuote(quote: Domain.QuoteItem) {
        viewContext.performAndWait { [weak self] in
            guard let self else { return }
            let request = QuoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", quote.id as CVarArg)

            do {
                if let quoteEntity = try self.viewContext.fetch(request).first {
                    self.viewContext.delete(quoteEntity)
                    try self.viewContext.save()
                }
            } catch {
                self.viewContext.rollback()
                self.crashlyticsManager.record(error)
            }
        }
    }

    func deleteBook(book: Domain.BookItem) {
        viewContext.performAndWait { [weak self] in
            guard let self else { return }
            let request = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)

            do {
                if let bookEntity = try self.viewContext.fetch(request).first {
                    self.viewContext.delete(bookEntity)
                    try self.viewContext.save()
                }
            } catch {
                self.viewContext.rollback()
                self.crashlyticsManager.record(error)
            }
        }
    }

    func saveBook(for book: Domain.BookItem) {
        viewContext.performAndWait { [weak self] in
            guard let self else { return }
            do {
                let bookEntity = BookEntity(context: self.viewContext)
                bookEntity.id = book.id
                bookEntity.author = book.author
                bookEntity.title = book.title
                bookEntity.coverImage = book.coverImageData

                try self.viewContext.save()
            } catch {
                self.viewContext.rollback()
                self.crashlyticsManager.record(error)
            }
        }
    }

    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity? {
        var result: BookEntity?
        viewContext.performAndWait {
            let request = BookEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", domainBook.id as CVarArg)

            do { result = try viewContext.fetch(request).first }
            catch { crashlyticsManager.record(error) }
        }
        return result
    }

    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity] {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "book.id == %@", selectedBook.id as CVarArg)
        var result: [QuoteEntity] = []
        viewContext.performAndWait {
            do {
                result = try viewContext.fetch(request)
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity? {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quote.id as CVarArg)
        var result: BookEntity?
        viewContext.performAndWait {
            do {
                let quotes = try viewContext.fetch(request)
                result = quotes.first?.book
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func fetchAllQuotes() -> [QuoteEntity] {
        let request = QuoteEntity.fetchRequest()
        var result: [QuoteEntity] = []
        viewContext.performAndWait {
            do {
                result = try viewContext.fetch(request)
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func fetchCategories() -> [String] {
        var result: [String] = []
        viewContext.performAndWait {
            let request = QuoteEntity.fetchRequest()
            do {
                let allQuotes = try viewContext.fetch(request)
                result = Array(Set(allQuotes.compactMap(\.category)))
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func fetchBooksCount() -> Int {
        let request = BookEntity.fetchRequest()
        var result = 0
        viewContext.performAndWait {
            do {
                result = try viewContext.count(for: request)
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }

    func fetchQuotesCount() -> Int {
        let request = QuoteEntity.fetchRequest()
        var result = 0
        viewContext.performAndWait {
            do {
                result = try viewContext.count(for: request)
            } catch {
                crashlyticsManager.record(error)
            }
        }
        return result
    }
}
