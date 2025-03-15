//
//  Domain.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/01/2025.
//

import SwiftUI

struct Domain {
    struct SuggestedBookItem: Identifiable {
        enum Cover {
            case remote(URL)
            case `default`
        }
        
        let id = UUID()
        let title: String
        let author: String
        let cover: Cover
        var coverImageData: Data?
    }
    
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
    
    struct QuoteItem: Identifiable, Equatable, Hashable {
        let id: UUID
        let text: String
        let page: Int64
        let category: String
        let date: Date
        let note: String
    }
}

//MARK: - Extensions

extension Domain.SuggestedBookItem {
    init?(model: BookDoc) {
        guard let title = model.title else { return nil }
        self.title = title
        self.author = model.authorName?.joined(separator: ", ") ?? ""
        self.coverImageData = nil
        
        if let editionKey = model.coverEditionKey, let url = URL(string: "https://covers.openlibrary.org/b/olid/\(editionKey)-M.jpg?default=false") {
            self.cover = .remote(url)
        } else if let coverKey = model.coverKey, let url = URL(string: "https://covers.openlibrary.org/b/id/\(coverKey)-M.jpg?default=false") {
            self.cover = .remote(url)
        } else {
            self.cover = .default
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

extension Domain.QuoteItem {
    init?(quoteEntity: QuoteEntity) {
        guard let id = quoteEntity.id, let text = quoteEntity.text, let category = quoteEntity.category, let date = quoteEntity.date else { return nil }
            
        self.id = id
        self.text = text
        self.page = quoteEntity.page
        self.category = category
        self.date = date
        self.note = quoteEntity.note ?? ""
    }
}
