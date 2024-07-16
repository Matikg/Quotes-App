//
//  MainScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/07/2024.
//

import SwiftUI

class MainScreenViewModel: ObservableObject {
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
    
    @Published var state: BookListState = /*.empty*/
        .loaded([BookItem(title: "Atomic Habits", author: "James Clear", coverImage: nil, quotesNumber: 5), BookItem(title: "Mock2", author: "Mock2", coverImage: nil, quotesNumber: 10)])
    
    //MARK: - Methods
    
    func addQuote() {
        print("Quote has been added")
    }
}
