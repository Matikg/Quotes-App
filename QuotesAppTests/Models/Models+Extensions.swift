import Foundation
@testable import QuotesApp

extension BookDoc: @retroactive Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(authorName, forKey: .authorName)
        try container.encode(coverEditionKey, forKey: .coverEditionKey)
        try container.encode(coverKey, forKey: .coverKey)
    }
}

extension SearchResponse: @retroactive Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(numFound, forKey: .numFound)
        try container.encode(docs, forKey: .docs)
    }

    enum CodingKeys: String, CodingKey {
        case numFound
        case docs
    }
}
