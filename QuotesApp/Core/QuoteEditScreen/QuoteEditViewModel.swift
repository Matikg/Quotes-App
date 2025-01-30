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
    }
    
    @Injected private var coreDataManager: CoreDataManagerProtocol
    @Injected private var navigationRouter: any NavigationRouting
    @Injected(scope: .feature("addQuote")) private var addBookRepository: AddBookRepositoryInterface
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var errors = [InputError: String]()
    
    deinit {
        print("quoteEdit deinit")
        DIContainerManager.shared
            .removeContainer(for: .feature("addQuote"))
    }
    
    func onAppear() {
        print("addBookRepository.title: \(addBookRepository.savedBookTitle)")
    }
    
    func saveQuote() {
        validate()
        
        guard errors.isEmpty else { return }
        guard let page = Int(pageInput) else { return }
        
        coreDataManager.saveQuote(
            text: quoteInput,
            category: categoryInput,
            page: page,
            note: noteInput
        )
        navigationRouter.pop()
    }
    
    func addBook() {
        navigationRouter.push(route: .book)
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
    }
}
