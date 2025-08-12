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
        
        var imageData: Data? {
            guard case .image(let data) = self else {
                return nil
            }
            return data
        }
    }
    
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var apiService: BookApiService
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    
    @Published var titleInput = ""
    @Published var authorInput = ""
    @Published var errors = [InputError: String]()
    @Published var foundBooks = [Domain.SuggestedBookItem]()
    @Published var didSelectSuggestion = false
    @Published var selectedBook: Domain.SuggestedBookItem?
    @Published var coverImage: CoverImageState = .default
    @Published var isTitleEditing = false
    @Published var isSearching = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $authorInput
            .sink { [weak self] _ in
                self?.selectedBook = nil
            }
            .store(in: &cancellables)
        
        $titleInput
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self, isTitleEditing else { return }
                
                selectedBook = nil
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
    
    //MARK: - Methods
    
    func resetCover() {
        coverImage = .default
    }
    
    func selectBook(_ book: Domain.SuggestedBookItem) {
        didSelectSuggestion = true
        titleInput = book.title
        authorInput = book.author
        selectedBook = book
        foundBooks = []
        
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
    
    func saveBook() {
        validate()
        
        guard errors.isEmpty else { return }

        let id = selectedBook?.id ?? UUID()
        let title = selectedBook?.title ?? titleInput
        let author = selectedBook?.author ?? authorInput
        let coverData = selectedBook?.coverImageData ?? coverImage.imageData
        let book = Domain.BookItem(
            id: id,
            title: title,
            author: author,
            quotesNumber: 0,
            coverImageData: coverData
        )
        
        saveQuoteRepository.selectBook(book)
        saveQuoteRepository.saveBook(book)
        
        navigationRouter.pop()
    }
    
    private func searchBooks() {
        isSearching = true
        Task {
            let books = try await apiService.fetchBooks(for: titleInput)
            foundBooks = books.compactMap { Domain.SuggestedBookItem(model: $0) }
            await MainActor.run {
                self.isSearching = false
            }
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
