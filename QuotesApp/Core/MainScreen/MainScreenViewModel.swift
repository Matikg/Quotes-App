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
    
    @Published var state: BookListState = .empty
    
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var coreDataManager: CoreDataManagerProtocol
    
    //MARK: - Methods
    
    func addQuote() {
        navigationRouter.push(route: .edit)
        ContainerManager.shared
            .container(for: .feature(FeatureName.addQuote.rawValue))
            .register(AddBookRepositoryInterface.self, instance: AddBookRepository())
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
