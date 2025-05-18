//
//  BookQuotesView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/03/2025.
//

import SwiftUI

struct BookQuotesView: View {
    @ObservedObject var viewModel: BookQuotesViewModel
    @State private var activeRow: UUID? = nil
    
    var body: some View {
        ScreenView {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 30) {
                    ForEach(viewModel.quotes) { quote in
                        QuotesListRowView(
                            quote: quote,
                            activeRow: $activeRow,
                            action: {
                                viewModel.selectQuote(quote)
                            },
                            onDelete: {
                                viewModel.deleteQuote(quote)
                            }
                        )
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 30)
            }
            
            Spacer()
            
            QButton(label: "Button_add_quote", state: viewModel.buttonState) {
                viewModel.addQuote()
            }
        }
        .navBar {
            VStack(spacing: 8) {
                QText(viewModel.book.title, type: .bold, size: .medium)
                    .lineLimit(1)
                QText(viewModel.book.author, type: .regular, size: .vsmall)
            }
        }
    }
}

#Preview {
    BookQuotesView(viewModel: BookQuotesViewModel(book: Domain.BookItem(id: UUID(), title: "Mock", author: "Mock", quotesNumber: 0, coverImageData: nil)))
}
