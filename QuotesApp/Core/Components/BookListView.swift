//
//  BookListView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 16/02/2025.
//

import SwiftUI

struct BookListView: View {
    private let books: [Domain.BookItem]
    private let showQuotesNumber: Bool
    private let onBookSelected: (Domain.BookItem) -> Void
    
    init(books: [Domain.BookItem], showQuotesNumber: Bool, onBookSelected: @escaping (Domain.BookItem) -> Void) {
        self.books = books
        self.showQuotesNumber = showQuotesNumber
        self.onBookSelected = onBookSelected
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(books) { book in
                    BookListRowView(book: book, showQuotesNumber: showQuotesNumber) {
                        onBookSelected(book)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 30)
        }
    }
}
