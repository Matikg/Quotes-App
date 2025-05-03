//
//  BookItem.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import SwiftUI

extension Domain {
    struct BookItem: Identifiable, Equatable, Hashable {
        let id: UUID
        let title: String
        let author: String
        let quotesNumber: Int
        let coverImageData: Data?
        
        var coverImage: Image? {
            if let data = coverImageData, let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
            return nil
        }
    }
}

extension Domain.BookItem {
    init?(bookEntity: BookEntity) {
        guard let id = bookEntity.id, let title = bookEntity.title, let author = bookEntity.author else {
            return nil
        }
        self.id = id
        self.title = title
        self.author = author
        self.quotesNumber = bookEntity.quotes?.count ?? 0
        self.coverImageData = bookEntity.coverImage
    }
}

extension Domain.BookItem {
    init(from suggestedBook: Domain.SuggestedBookItem) {
        self.id = suggestedBook.id
        self.title = suggestedBook.title
        self.author = suggestedBook.author
        self.quotesNumber = 0
        self.coverImageData = suggestedBook.coverImageData
    }
}
