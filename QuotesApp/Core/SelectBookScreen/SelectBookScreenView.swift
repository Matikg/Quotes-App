//
//  SelectBookScreenView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/02/2025.
//

import SwiftUI

struct SelectBookScreenView: View {
    @StateObject var viewModel = SelectBookScreenViewModel()
    
    var body: some View {
        BackgroundStack {
            BookListView(books: viewModel.books, showQuotesNumber: false) { book in
                viewModel.selectBook(book: book)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                QText("BookSelect_title", type: .bold, size: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.createBook()
                } label: {
                    Text("Create")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background, for: .navigationBar)
    }
}

#Preview {
    SelectBookScreenView()
}
