//
//  ContentView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

struct MainScreenView: View {
    typealias BookItem = MainScreenViewModel.BookItem
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        BackgroundStack {
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
    
    private func buildLoadedListView(books: [BookItem]) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(books) { book in
                        BookListRowView(book: book)
                            .padding(.horizontal)
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 30)
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
