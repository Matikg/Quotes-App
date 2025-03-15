//
//  QuoteEditViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation
import DependencyInjection

final class QuoteEditViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case quote = "Quote_empty_dialog"
        case page = "Page_empty_dialog"
        case category = "Category_empty_dialog"
        case book = "Book_empty_dialog"
    }
    
    @Injected private var coreDataManager: CoreDataManagerProtocol
    @Injected private var navigationRouter: any NavigationRouting
    @Injected(scope: .feature(FeatureName.addQuote.rawValue)) private var addBookRepository: SaveQuoteRepositoryInterface
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var bookButtonLabel = ""
    @Published var errors = [InputError: String]()
    
    private let existingQuote: Domain.QuoteItem?
    
    init(existingQuote: Domain.QuoteItem? = nil) {
        self.existingQuote = existingQuote
        if let quote = existingQuote {
            self.quoteInput = quote.text
            self.categoryInput = quote.category
            self.pageInput = String(quote.page)
            self.noteInput = quote.note
        }
    }
    
    deinit {
        ContainerManager.shared
            .removeContainer(for: .feature(FeatureName.addQuote.rawValue))
    }
    
    //MARK: - Methods
    
    func onAppear() {
        if let savedBook = addBookRepository.selectedBook {
            bookButtonLabel = "\(savedBook.title), \(savedBook.author)"
        }
    }
    
    func saveQuote() {
        validate()
        
        guard errors.isEmpty else { return }
        guard let page = Int(pageInput) else { return }
        guard let selectedBook = addBookRepository.selectedBook else { return }
        guard let bookEntity = coreDataManager.fetchBookEntity(for: selectedBook) else { return }
        
        coreDataManager.saveQuote(
            to: bookEntity,
            text: quoteInput,
            category: categoryInput,
            page: page,
            note: noteInput,
            quoteId: existingQuote?.id
        )
        navigationRouter.popAll()
    }
    
    func addBook() {
        let route: Route = coreDataManager.fetchBooks().isEmpty ? .book : .select
        navigationRouter.push(route: route)
    }
    
    private func validate() {
        errors.removeAll()
        
        if quoteInput.isEmpty {
            errors[.quote] = InputError.quote.rawValue
        }
        if pageInput.isEmpty || Int(pageInput) == nil {
            errors[.page] = InputError.page.rawValue
        }
        if categoryInput.isEmpty {
            errors[.category] = InputError.category.rawValue
        }
        if addBookRepository.selectedBook == nil {
            errors[.book] = InputError.book.rawValue
        }
    }
}
