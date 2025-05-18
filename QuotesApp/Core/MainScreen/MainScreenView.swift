//
//  ContentView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        ScreenView {
            VStack {
                QText("WelcomeScreen_title", type: .bold, size: .large)
                    .padding(.top, 30)
                
                switch viewModel.state {
                case .empty:
                    buildEmptyListView()
                    
                case let .loaded(books):
                    buildLoadedListView(books: books)
                }
            }
            .onAppear {
                viewModel.getBooks()
            }
        }
    }
    
    //MARK: - View Builders
    
    private func buildEmptyListView() -> some View {
        VStack {
            Spacer()
            Image(.bookshelf)
                .padding(.bottom, 30)
            
            QText("MainScreen_empty_quote", type: .bold, size: .medium)
            
            QButton(label: "Button_add_quote", state: viewModel.buttonState) {
                viewModel.addQuote()
            }
            
            Spacer()
        }
    }
    
    private func buildLoadedListView(books: [Domain.BookItem]) -> some View {
        VStack {
            BookListView(
                books: books,
                showQuotesNumber: true
            ) { selectedBook in
                viewModel.selectBook(selectedBook)
            } onBookDeleted: { book in
                viewModel.bookToDelete = book
            }
            
            QButton(label: "Button_add_quote", state: viewModel.buttonState) {
                viewModel.addQuote()
            }
        }
        .alert(item: $viewModel.bookToDelete) { book in
            Alert(
                title: Text("Book_delete_alert"),
                message: Text("Book_delete_message_alert"),
                primaryButton: .destructive(Text("Book_delete_alert"), action: {
                    viewModel.deleteBook(book)
                }),
                secondaryButton: .cancel({
                    viewModel.cancelDeleteBook()
                })
            )
        }
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
