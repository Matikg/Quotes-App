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
        ScreenView {
            BookListView(books: viewModel.books, showQuotesNumber: false) { book in
                viewModel.selectBook(book: book)
            }
            .onAppear { viewModel.onAppear() }
        }
        .navBar(center: {
            QText("BookSelect_title", type: .bold, size: .medium)
        }, trailing: {
            Button {
                viewModel.createBook()
            } label: {
                QText("Create", type: .regular, size: .small)
            }
        })
    }
}

#Preview {
    SelectBookScreenView()
}
