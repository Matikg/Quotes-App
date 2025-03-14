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
            Image(.emptyBox)
                .padding(.bottom, 30)
            
            QText("MainScreen_empty_quote", type: .bold, size: .medium)
            
            QButton(label: "Button_add_quote") {
                viewModel.addQuote()
            }
            
            Spacer()
        }
    }
    
    private func buildLoadedListView(books: [Domain.BookItem]) -> some View {
        VStack {
            BookListView(books: books, showQuotesNumber: true) { selectedBook in
                viewModel.selectBook(selectedBook)
            }
            
            QButton(label: "Button_add_quote") {
                viewModel.addQuote()
            }
        }
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
