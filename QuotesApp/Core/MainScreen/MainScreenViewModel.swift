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
        let bookItems = fetchedBooks.map(BookItem.init)
        state = bookItems.isEmpty ? .empty : .loaded(bookItems)
    }
}

extension MainScreenViewModel.BookItem {
    init(bookEntity: BookEntity) {
        self.title = bookEntity.title ?? ""
        self.author = bookEntity.author ?? ""
        self.quotesNumber = bookEntity.quotes?.count ?? 0
        
        if let coverData = bookEntity.coverImage, let uiImage = UIImage(data: coverData) {
            self.coverImage = Image(uiImage: uiImage)
        } else {
            self.coverImage = nil
        }
    }
}
