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
        BackgroundStack {
            VStack {
                Text(String(localized: "WelcomeScreen_title"))
                    .font(.system(size: 32))
                    .bold()
                    .padding(.top, 30)
                
                switch viewModel.state {
                case .empty:
                    buildEmptyListView()
                    
                case .loaded(let books):
                    buildLoadedListView(books: books)
                }
            }
            .foregroundStyle(Color.accentColor)
        }
    }
    
    //MARK: - View Builders
    
    private func buildEmptyListView() -> some View {
        VStack {
            Spacer()
            Image(.emptyBox)
                .padding(.bottom, 30)
            
            Text(String(localized: "MainScreen_empty_quote"))
                .font(.system(size: 18))
                .bold()
            
            CustomButton(label: "Add quote") {
                viewModel.addQuote()
            }
            
            Spacer()
        }
    }
    
    private func buildLoadedListView(books: [MainScreenViewModel.BookItem]) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(books) { book in
                        BookListRowView(book: book)
                        
                        Divider()
                            .padding(.vertical)
                    }
                }
            }
            
            CustomButton(label: "Add quote") {
                viewModel.addQuote()
            }
        }
        .padding(.top, 40)
    }
}


#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
