//
//  Book Models.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/01/2025.
//

import Foundation

struct SearchResponse: Decodable {
    let numFound: Int?
    let docs: [BookDoc]?
}

struct BookDoc: Decodable {
    let title: String?
    let authorName: [String]?
    let coverEditionKey: String?
    let coverKey: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case coverEditionKey = "cover_edition_key"
        case coverKey = "cover_i"
    }
}
