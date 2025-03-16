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
    @Injected(scope: .feature(FeatureName.addQuote.rawValue)) private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    let quote: Domain.QuoteItem
    var book: Domain.BookItem?
    
    init(quote: Domain.QuoteItem) {
        self.quote = quote
        getBook()
    }
    
    //MARK: - Methods
    
    func editQuote() {
        // W tym miejscu jest problem z książką
        navigationRouter.push(route: .edit(existingQuote: quote))
        ContainerManager.shared
            .container(for: .feature(FeatureName.addQuote.rawValue))
            .register(SaveQuoteRepositoryInterface.self, instance: SaveQuoteRepository())
        if let book {
            saveQuoteRepository.selectBook(book)
        }
    }
    
    private func getBook() {
        book = coreDataManager.fetchBook(for: quote).flatMap(Domain.BookItem.init)
    }
}

