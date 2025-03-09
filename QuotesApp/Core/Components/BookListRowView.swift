//
//  BookListRowView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 15/07/2024.
//

import SwiftUI

struct BookListRowView: View {
    private let book: Domain.BookItem
    private let showQuotesNumber: Bool
    private let action: () -> Void
    
    init(book: Domain.BookItem, showQuotesNumber: Bool, action: @escaping () -> Void) {
        self.book = book
        self.showQuotesNumber = showQuotesNumber
        self.action = action
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 20) {
                    coverImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 100)
                    
                    buildBookInfoView()
                }
                Spacer()
                
                if showQuotesNumber {
                    buildQuotesNumberView()
                }
            }
            Divider()
                .padding(.vertical)
        }
        .contentShape(.rect)
        .onTapGesture {
            action()
        }
    }
    
    //MARK: - View Builders
    
    private var coverImage: Image {
        book.coverImage ?? Image(.defaultBookCover)
    }
    
    private func buildQuotesNumberView() -> some View {
        ZStack {
            Rectangle()
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(width: 60, height: 73)
            
            VStack(spacing: 10) {
                QText("MainScreen_quotes_count", type: .regular, size: .vsmall)
                QText(String(book.quotesNumber), type: .bold, size: .medium)
            }
        }
    }
    
    private func buildBookInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            QText(book.title, type: .bold, size: .medium)
            QText(book.author, type: .regular, size: .vsmall)
        }
        .lineLimit(1)
    }
}

#Preview {
    BookListRowView(book: Domain.BookItem(id: UUID(), title: "Title", author: "Author", quotesNumber: 5, coverImageData: nil), showQuotesNumber: true, action: { })
}
