//
//  SelectBookScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/02/2025.
//

import SwiftUI
import DependencyInjection

final class SelectBookScreenViewModel: ObservableObject {
    @Injected private var coreDataManager: CoreDataManagerInterface
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    @Injected private var purchaseManager: PurchaseManagerInterface
    
    @Published var books = [Domain.BookItem]()
    
    //MARK: - Methods
    
    @MainActor
    func createBook() {
        Task {
            let canAddQuote = await purchaseManager.checkPremiumAction()
            if canAddQuote {
                navigationRouter.push(route: .book)
            } else {
                navigationRouter.present(sheet: .paywall)
            }
        }
    }
    
    func selectBook(book: Domain.BookItem) {
        saveQuoteRepository.selectBook(book)
        navigationRouter.pop()
    }
    
    func onAppear() {
        getBooks()
    }
    
    private func getBooks() {
        let fetchedBooks = coreDataManager.fetchBooks()
        books = fetchedBooks.compactMap(Domain.BookItem.init)
    }
}
