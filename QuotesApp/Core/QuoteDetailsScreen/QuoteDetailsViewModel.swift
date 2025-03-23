//
//  QuoteDetailsViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/03/2025.
//

import Foundation
import DependencyInjection

final class QuoteDetailsViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var coreDataManager: CoreDataManagerProtocol
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    let quote: Domain.QuoteItem
    var book: Domain.BookItem?
    
    init(quote: Domain.QuoteItem) {
        self.quote = quote
        getBook()
    }
    
    //MARK: - Methods
    
    func editQuote() {
        navigationRouter.push(route: .edit(existingQuote: quote))
        
        if let book {
            saveQuoteRepository.selectBook(book)
        }
    }
    
    private func getBook() {
        book = coreDataManager.fetchBook(for: quote).flatMap(Domain.BookItem.init)
    }
}

