//
//  BookScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation
import DependencyInjection

final class BookScreenViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case title = "Title_empty_dialog"
        case author = "Author_empty_dialog"
    }
    
    @Injected(\.navigationRouter) var navigationRouter
    
    private let apiService = ApiService()
    
    @Published var titleInput = ""
    @Published var authorInput = ""
    @Published var errors = [InputError: String]()
    @Published var foundBooks = [BookDoc]()
    @Published var coverURL: URL?
    @Published var didSelectSuggestion: Bool = false
    
    @MainActor
    func searchBooks() async {
        do {
            let books = try await apiService.fetchBooks(for: titleInput)
            foundBooks = books
        } catch {
            print("Błąd pobierania książek: \(error)")
            foundBooks = []
        }
    }
    
    func selectBook(_ book: BookDoc) {
        didSelectSuggestion = true
        titleInput = book.title ?? ""
        authorInput = book.authorName?.joined(separator: ", ") ?? ""
        foundBooks = []
        
        if let coverEditionKey = book.coverEditionKey {
            coverURL = URL(string: "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg?default=false")
        } else if let coverKey = book.coverKey {
            coverURL = URL(string: "https://covers.openlibrary.org/b/id/\(coverKey)-M.jpg?default=false")
        } else {
            coverURL = nil
        }
    }
    
    func saveBook() {
        validate()
        
        guard errors.isEmpty else { return }
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
