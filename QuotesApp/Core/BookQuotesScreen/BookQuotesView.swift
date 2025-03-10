//
//  BookQuotesView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/03/2025.
//

import SwiftUI

struct BookQuotesView: View {
    @ObservedObject var viewModel: BookQuotesViewModel
    
    var body: some View {
        BackgroundStack {
            VStack {
                QText(viewModel.book.author, type: .regular, size: .vsmall)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.quotes) { quote in
                            QuotesListRowView(quote: quote)
                                .padding(.horizontal)
                        }
                    }
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 50)
                }
                
                QButton(label: "Button_add_quote") {
                    
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                QText(String(viewModel.book.title.prefix(20)), type: .bold, size: .medium)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background, for: .navigationBar)
    }
}

#Preview {
    BookQuotesView(viewModel: BookQuotesViewModel(book: Domain.BookItem(id: UUID(), title: "Mock", author: "Mock", quotesNumber: 0, coverImageData: nil)))
}
