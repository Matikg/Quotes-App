//
//  BookListRowView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 15/07/2024.
//

import SwiftUI

struct BookListRowView: View {
    let book: MainScreenViewModel.BookItem
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                coverImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 76, height: 100)
                
                buildBookInfoView()
                
                Spacer()
                
                buildQuotesNumberView()
            }
            
            Divider()
                .padding(.vertical)
        }
    }
    
    //MARK: - View Builders
    
    private var coverImage: Image {
        book.coverImage ?? Image(.defaultBookCover)
    }
    
    private func buildBookInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            QText(book.title, type: .bold, size: .medium)
            QText(book.author, type: .regular, size: .vsmall)
        }
        .lineLimit(1)
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
}

#Preview {
    BookListRowView(book: MainScreenViewModel.BookItem(title: "Title", author: "Author", coverImage: nil, quotesNumber: 5))
}
