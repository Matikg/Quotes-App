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
    
    @Published var quotes = [Domain.QuoteItem]()
    
    let book: Domain.BookItem
    
    init(book: Domain.BookItem) {
        self.book = book
        getQuotes()
    }
    
    //MARK: - Methods
    
    func selectQuote(_ quote: Domain.QuoteItem) {
        navigationRouter.push(route: .details(quote: quote))
    }
    
    func addQuote() {
        navigationRouter.push(route: .edit(existingQuote: nil))
        saveQuoteRepository.selectBook(book)
    }
    
    func deleteQuote(_ quote: Domain.QuoteItem) {
        coreDataManager.deleteQuote(quote: quote)
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes.remove(at: index)
        }
    }
    
    private func getQuotes() {
        let fetchedQuotes = coreDataManager.fetchQuotes(for: book)
        quotes = fetchedQuotes.compactMap(Domain.QuoteItem.init)
    }
}
