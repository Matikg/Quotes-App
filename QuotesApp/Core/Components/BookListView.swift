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
    private let onBookDeleted: (Domain.BookItem) -> Void
    
    @State private var activeRow: UUID? = nil
    
    init(
        books: [Domain.BookItem],
        showQuotesNumber: Bool,
        onBookSelected: @escaping (Domain.BookItem) -> Void,
        onBookDeleted: @escaping (Domain.BookItem) -> Void
    ) {
        self.books = books
        self.showQuotesNumber = showQuotesNumber
        self.onBookSelected = onBookSelected
        self.onBookDeleted = onBookDeleted
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 25) {
                ForEach(books) { book in
                    BookListRowView(
                        book: book,
                        showQuotesNumber: showQuotesNumber,
                        activeRow: $activeRow
                    ) {
                        onBookSelected(book)
                    } onDelete: {
                        onBookDeleted(book)
                    }
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 30)
        }
    }
}
