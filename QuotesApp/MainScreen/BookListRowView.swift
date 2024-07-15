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
        HStack(spacing: 20) {
            Image(book.coverImage ?? "defaultBookCover")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 76, height: 100)
                .clipShape(Rectangle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .font(.system(size: 18))
                    .bold()
                    .lineLimit(1)
                Text(book.author)
                    .font(.system(size: 12))
                    .lineLimit(1)
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 2)
                    .frame(width: 60, height: 73)
                
                VStack(spacing: 10) {
                    Text("Quotes")
                        .font(.system(size: 12))
                    
                    Text(String(book.numberOfQuotes))
                        .font(.system(size: 20))
                        .bold()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    BookListRowView(book: MainScreenViewModel.BookItem(title: "Title", author: "Author", coverImage: nil, numberOfQuotes: 5))
}
