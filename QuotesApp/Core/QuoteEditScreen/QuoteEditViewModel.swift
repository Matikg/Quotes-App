//
//  QuoteEditViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation
import DependencyInjection

final class QuoteEditViewModel: ObservableObject {
    @Injected(\.coreDataManager) var coreDataManager: CoreDataManagerProtocol
    @Injected(\.navigationRouter) var navigationRouter
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var showError = false
    
    func saveQuote() {
        if !quoteInput.isEmpty {
            coreDataManager.saveQuote(text: quoteInput, category: categoryInput, page: Int(pageInput)!, note: noteInput)
            navigationRouter.pop()
        }
        else {
            showError = true
        }
    }
}
