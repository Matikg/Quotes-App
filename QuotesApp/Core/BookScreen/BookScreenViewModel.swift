//
//  BookScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation
import DependencyInjection
import Combine

final class BookScreenViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case title = "Title_empty_dialog"
        case author = "Author_empty_dialog"
    }
    
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var apiService: ApiService
    @Injected(scope: .feature("addQuote")) private var addBookRepository: AddBookRepositoryInterface
    
    @Published var titleInput = ""
    @Published var authorInput = ""
    @Published var errors = [InputError: String]()
    @Published var foundBooks = [Domain.Book]()
    @Published var didSelectSuggestion: Bool = false
    @Published var selectedBook: Domain.Book?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $titleInput
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                
                guard !value.isEmpty else {
                    foundBooks = []
                    didSelectSuggestion = false
                    return
                }
                if didSelectSuggestion {
                    didSelectSuggestion = false
                    return
                }
                searchBooks()
            }
            .store(in: &cancellables)
    }
    
    func selectBook(_ book: Domain.Book) {
        didSelectSuggestion = true
        titleInput = book.title
        authorInput = book.author
        selectedBook = book
        foundBooks = []
    }
    
    func saveBook() {
        //TODO: Saving to CoreData
        validate()
        addBookRepository.saveBook(with: "test :)")
        
        guard errors.isEmpty else { return }
    }
    
    private func searchBooks() {
        Task {
            let books = try await apiService.fetchBooks(for: titleInput)
            foundBooks = books.compactMap { Domain.Book(model: $0) }
        }
    }
    
    private func validate() {
        errors.removeAll()
        
        if titleInput.isEmpty {
            errors[.title] = InputError.title.rawValue
        }
        if authorInput.isEmpty {
            errors[.author] = InputError.author.rawValue
        }
    }
}
