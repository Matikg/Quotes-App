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
        case loaded([BookItem])
    }
    
    struct BookItem: Identifiable {
        let id = UUID()
        let title: String
        let author: String
        let coverImage: Image?
        let quotesNumber: Int
    }
    
    @Published var state: BookListState = .empty
    
    @Injected(\.navigationRouter) var navigationRouter
    @Injected(\.coreDataManager) var coreDataManager
    
    //MARK: - Methods
    
    func addQuote() {
        navigationRouter.push(route: .edit)
    }
    
    func getBooks() {
        let fetchedBooks = coreDataManager.fetchBooks()
        let bookItems = fetchedBooks.map(BookItem.init)
        state = bookItems.isEmpty ? .empty : .loaded(bookItems)
    }
}

extension MainScreenViewModel.BookItem {
    init(bookEntity: BookEntity) {
        self.title = bookEntity.title ?? ""
        self.author = bookEntity.author ?? ""
        self.coverImage = nil
        self.quotesNumber = bookEntity.quotes?.count ?? 0
    }
}
