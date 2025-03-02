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
    @Injected(scope: .feature(FeatureName.addQuote.rawValue)) private var addBookRepository: AddBookRepositoryInterface
    
    @Published var books = [Domain.BookItem]()
    
    func createBook() {
        navigationRouter.push(route: .book)
    }
    
    func getBooks() {
        let fetchedBooks = coreDataManager.fetchBooks()
        let bookItems = fetchedBooks.compactMap(Domain.BookItem.init)
        books = bookItems.isEmpty ? [] : bookItems
    }
    
    func selectBook(book: Domain.BookItem) {
        addBookRepository.selectBook(book)
        navigationRouter.pop()
    }
}
