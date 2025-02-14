//
//  Domain.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/01/2025.
//

import Foundation

struct Domain {
    struct Book: Identifiable {
        let id = UUID()
        let title: String
        let author: String
        let cover: Cover
        var coverImageData: Data?
    }
}

enum Cover {
    case remote(URL)
    case `default`
}

extension Domain.Book {
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
