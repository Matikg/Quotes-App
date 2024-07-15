//
//  MainScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/07/2024.
//

import Foundation

class MainScreenViewModel: ObservableObject {
    @Published var state: BookListState = /*.empty*/
        .loaded([BookItem(title: "Atomic Habits", author: "James Clear", coverImage: nil, numberOfQuotes: 5), BookItem(title: "Mock2", author: "Mock2", coverImage: nil, numberOfQuotes: 10)])
    
    enum BookListState {
        case empty
        case loaded([BookItem])
    }
    
    struct BookItem: Identifiable {
        var id = UUID()
        var title: String
        var author: String
        var coverImage: String?
        var numberOfQuotes: Int
    }
        
    //MARK: - Methods
    
    func addQuote() {
        print("Quote has been added")
    }
}
