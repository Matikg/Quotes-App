import Combine
import DependencyInjection
import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class BookScreenViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case title = "form_error_title_empty"
        case author = "form_error_author_empty"
    }

    enum CoverImageState {
        case `default`
        case loading
        case image(Data)

        var imageData: Data? {
            guard case let .image(data) = self else {
                return nil
            }
            return data
        }
    }

    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var apiService: BookApiService
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface

    @Published private(set) var errors = [InputError: String]()
    @Published private(set) var foundBooks = [Domain.SuggestedBookItem]()
    @Published private(set) var didSelectSuggestion = false
    @Published private(set) var selectedBook: Domain.SuggestedBookItem?
    @Published private(set) var coverImage: CoverImageState = .default
    @Published private(set) var isSearching = false
    @Published var titleInput = ""
    @Published var authorInput = ""

    private var cancellables = Set<AnyCancellable>()
    private var coverTask: Task<Void, Never>?

    init() {
        $authorInput
            .sink { [weak self] _ in
                self?.selectedBook = nil
            }
            .store(in: &cancellables)

        $titleInput
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }

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
                Task { await self.searchBooks() }
            }
            .store(in: &cancellables)
    }

    deinit {
        coverTask?.cancel()
    }

    // MARK: - Methods

    func resetCover() {
        coverImage = .default
        if var selectedBook {
            selectedBook.coverImageData = nil
            self.selectedBook = selectedBook
        }
    }

    func setManualCover(data: Data) {
        coverImage = .image(data)
        if var selectedBook {
            selectedBook.coverImageData = data
            self.selectedBook = selectedBook
        }
    }

    func handleCoverSelection(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        await handleCoverSelectionLoad {
            try await item.loadTransferable(type: Data.self)
        }
    }

    func handleCoverSelectionLoad(_ loadData: @escaping @Sendable () async throws -> Data?) async {
        if let data = try? await loadData() {
            setManualCover(data: data)
        }
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
        case let .remote(url):
            coverImage = .loading

            coverTask?.cancel()
            coverTask = Task { [weak self] in
                guard let self else { return }

                do {
                    let data = try await apiService.fetchBookCover(from: url)
                    try Task.checkCancellation()
                    var updatedBook = book
                    updatedBook.coverImageData = data
                    selectedBook = updatedBook
                    coverImage = .image(data)

                } catch {
                    if !Task.isCancelled {
                        coverImage = .default
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
        let coverData = coverImage.imageData ?? selectedBook?.coverImageData
        let book = Domain.BookItem(
            id: id,
            title: title,
            author: author,
            quotesNumber: 0,
            coverImageData: coverData
        )

        saveQuoteRepository.selectBook(book)
        saveQuoteRepository.saveBook(book)

        let shouldReturnToQuoteEdit = saveQuoteRepository.shouldReturnToQuoteEditAfterBookSave
        saveQuoteRepository.setShouldReturnToQuoteEditAfterBookSave(false)
        navigationRouter.dismissSheet()
        if shouldReturnToQuoteEdit {
            navigationRouter.pop()
        }
    }

    func dismissBookScreen() {
        navigationRouter.dismissSheet()
    }

    private func searchBooks() async {
        isSearching = true
        defer { isSearching = false }

        do {
            let books = try await apiService.fetchBooks(for: titleInput)
            foundBooks = books.compactMap { Domain.SuggestedBookItem(model: $0) }
        } catch {
            foundBooks = []
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
