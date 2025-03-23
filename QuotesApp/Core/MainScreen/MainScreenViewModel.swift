//
//  MainScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/07/2024.
//

import SwiftUI
import DependencyInjection

final class MainScreenViewModel: ObservableObject {
    enum BookListState {
        case empty
        case loaded([Domain.BookItem])
    }
    
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var coreDataManager: CoreDataManagerProtocol
    
    @Published var state: BookListState = .empty
    
    //MARK: - Methods
    
    func addQuote() {
        navigationRouter.push(route: .edit(existingQuote: nil))
    }
    
    func getBooks() {
        let fetchedBooks = coreDataManager.fetchBooks()
        let bookItems = fetchedBooks.compactMap(Domain.BookItem.init)
        state = bookItems.isEmpty ? .empty : .loaded(bookItems)
    }
    
    func selectBook(_ book: Domain.BookItem) {
        navigationRouter.push(route: .quotes(book: book))
    }
}
