//
//  BookListRowView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 15/07/2024.
//

import SwiftUI

struct BookListRowView: View {
    var book: MainScreenViewModel.BookItem
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                coverImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
            Text(book.title)
                .font(.system(size: 18))
                .bold()
                .lineLimit(1)
            Text(book.author)
                .font(.system(size: 12))
        }
        .lineLimit(1)
    }
    
    private func buildQuotesNumberView() -> some View {
        ZStack {
            Rectangle()
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(width: 60, height: 73)
            
            VStack(spacing: 10) {
                Text(String(localized: "MainScreen_quotes_count"))
                    .font(.system(size: 12))
                
                Text(String(book.quotesNumber))
                    .font(.system(size: 20))
                    .bold()
            }
        }
    }
}

#Preview {
    BookListRowView(book: MainScreenViewModel.BookItem(title: "Title", author: "Author", coverImage: nil, quotesNumber: 5))
}
