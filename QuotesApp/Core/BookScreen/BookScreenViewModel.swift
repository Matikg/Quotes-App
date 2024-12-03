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
    
    @Published var titleInput = ""
    @Published var authorInput = ""
    @Published var errors = [InputError: String]()
    
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
