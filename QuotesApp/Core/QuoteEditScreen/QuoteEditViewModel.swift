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
    @Injected(scope: .feature(FeatureName.addQuote.rawValue)) private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var bookButtonLabel = ""
    @Published var errors = [InputError: String]()
    
    private let quoteId: UUID?
    
    init(existingQuote: Domain.QuoteItem? = nil) {
        self.quoteInput = existingQuote?.text ?? ""
        self.categoryInput = existingQuote?.category ?? ""
        self.noteInput = existingQuote?.note ?? ""
        self.quoteId = existingQuote?.id
        if let page = existingQuote?.page {
            self.pageInput = String(page)
        }
    }
    
    deinit {
        ContainerManager.shared
            .removeContainer(for: .feature(FeatureName.addQuote.rawValue))
    }
    
    //MARK: - Methods
    
    func onAppear() {
        if let savedBook = saveQuoteRepository.selectedBook {
            bookButtonLabel = "\(savedBook.title), \(savedBook.author)"
        }
    }
    
    func saveQuote() {
        validate()
        
        guard errors.isEmpty else { return }
        guard let page = Int(pageInput) else { return }
        guard let selectedBook = saveQuoteRepository.selectedBook else { return }
        guard let bookEntity = coreDataManager.fetchBookEntity(for: selectedBook) else { return }
        
        coreDataManager.saveQuote(
            to: bookEntity,
            text: quoteInput,
            category: categoryInput,
            page: page,
            note: noteInput,
            quoteId: quoteId
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
        if saveQuoteRepository.selectedBook == nil {
            errors[.book] = InputError.book.rawValue
        }
    }
}
