//
//  BookScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation
import DependencyInjection
import Combine

@MainActor
final class BookScreenViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case title = "Title_empty_dialog"
        case author = "Author_empty_dialog"
    }
    
    enum CoverImageState {
        case `default`
        case loading
        case image(Data)
    }
    
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var apiService: BookApiService
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    @Published var titleInput = ""
    @Published var authorInput = ""
    @Published var errors = [InputError: String]()
    @Published var foundBooks = [Domain.SuggestedBookItem]()
    @Published var didSelectSuggestion: Bool = false
    @Published var selectedBook: Domain.SuggestedBookItem?
    @Published var coverImage: CoverImageState = .default
    
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
        
        $selectedBook
            .sink { [weak self] selectedBook in
                guard let self else { return }
                
                guard let book = selectedBook else {
                    coverImage = .default
                    return
                }
                
                if let data = book.coverImageData {
                    coverImage = .image(data)
                    return
                }
                
                switch book.cover {
                case .remote(let url):
                    coverImage = .loading
                    
                    Task {
                        do {
                            let data = try await self.apiService.fetchBookCover(from: url)
                            await MainActor.run {
                                var updatedBook = book
                                updatedBook.coverImageData = data
                                self.selectedBook = updatedBook
                                self.coverImage = .image(data)
                            }
                        } catch {
                            await MainActor.run {
                                self.coverImage = .default
                            }
                        }
                    }
                case .default:
                    coverImage = .default
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    func selectBook(_ book: Domain.SuggestedBookItem) {
        didSelectSuggestion = true
        titleInput = book.title
        authorInput = book.author
        selectedBook = book
        foundBooks = []
    }
    
    func saveBook() {
        validate()
        
        guard errors.isEmpty else { return }
        
        let book = selectedBook.map(Domain.BookItem.init) ?? Domain.BookItem(from: Domain.SuggestedBookItem(title: titleInput, author: authorInput, cover: .default))
        
        saveQuoteRepository.selectBook(book)
        saveQuoteRepository.saveBook(book)
        
        navigationRouter.pop()
    }
    
    private func searchBooks() {
        Task {
            let books = try await apiService.fetchBooks(for: titleInput)
            foundBooks = books.compactMap { Domain.SuggestedBookItem(model: $0) }
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
