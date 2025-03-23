//
//  SelectBookScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/02/2025.
//

import SwiftUI
import DependencyInjection

final class SelectBookScreenViewModel: ObservableObject {
    @Injected private var coreDataManager: CoreDataManagerProtocol
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    @Published var books = [Domain.BookItem]()
    
    //MARK: - Methods
    
    func createBook() {
        navigationRouter.push(route: .book)
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
