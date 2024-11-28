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
    
    @Injected(\.coreDataManager) var coreDataManager
    @Injected(\.navigationRouter) var navigationRouter
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var errors = [InputError: String]()
    
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
    
    private func validate() {
        var newErrors = [InputError: String]()
        
        for errorCase in InputError.allCases {
            switch errorCase {
            case .quote:
                if quoteInput.isEmpty {
                    newErrors[.quote] = InputError.quote.rawValue
                }
            case .page:
                if pageInput.isEmpty || Int(pageInput) == nil {
                    newErrors[.page] = InputError.page.rawValue
                }
            case .category:
                if categoryInput.isEmpty {
                    newErrors[.category] = InputError.category.rawValue
                }
            }
            errors = newErrors
        }
    }
}
