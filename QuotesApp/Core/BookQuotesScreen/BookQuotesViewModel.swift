//
//  BookQuotesViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/03/2025.
//

import Foundation
import DependencyInjection

final class BookQuotesViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var coreDataManager: CoreDataManagerInterface
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    @Injected private var purchaseManager: PurchaseManagerInterface
    
    @Published var quotes = [Domain.QuoteItem]()
    @Published var buttonState: QButton.ButtonState = .idle
    
    let book: Domain.BookItem
    
    init(book: Domain.BookItem) {
        self.book = book
        getQuotes()
    }
    
    deinit {
        saveQuoteRepository.resetBook()
    }
    
    //MARK: - Methods
    
    func selectQuote(_ quote: Domain.QuoteItem) {
        navigationRouter.push(route: .details(quote: quote))
    }
    
    @MainActor
    func addQuote() {
        Task {
            buttonState = .loading
            let canAddQuote = await purchaseManager.checkPremiumAction()
            buttonState = .idle
            
            if canAddQuote {
                navigationRouter.push(route: .edit(existingQuote: nil))
            } else {
                navigationRouter.present(sheet: .paywall)
            }
        }
        saveQuoteRepository.selectBook(book)
    }
    
    func deleteQuote(_ quote: Domain.QuoteItem) {
        coreDataManager.deleteQuote(quote: quote)
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes.remove(at: index)
        }
        if quotes.isEmpty {
            navigationRouter.pop()
        }
    }
    
    private func getQuotes() {
        let fetchedQuotes = coreDataManager.fetchQuotes(for: book)
        quotes = fetchedQuotes.compactMap(Domain.QuoteItem.init)
    }
}
