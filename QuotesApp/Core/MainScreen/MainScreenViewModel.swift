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
    @Published var bookToDelete: Domain.BookItem? 
    
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
    
    func deleteBook(_ book: Domain.BookItem) {
        coreDataManager.deleteBook(book: book)
        
        switch state {
        case .empty:
            break
        case .loaded(let books):
            let updatedBooks = books.filter { $0.id != book.id }
            state = updatedBooks.isEmpty ? .empty : .loaded(updatedBooks)
        }
        
        cancelDeleteBook()
    }
    
    func cancelDeleteBook() {
        bookToDelete = nil
    }
}
