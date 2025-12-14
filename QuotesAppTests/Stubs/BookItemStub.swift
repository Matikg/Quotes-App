import Foundation
@testable import QuotesApp

enum BookItemStub {
    static func make(
        id: UUID = UUID(),
        title: String = "Test Book",
        author: String = "Test Author",
        quotesNumber: Int = 0,
        coverImageData: Data? = nil
    ) -> Domain.BookItem {
        Domain.BookItem(
            id: id,
            title: title,
            author: author,
            quotesNumber: quotesNumber,
            coverImageData: coverImageData
        )
    }
}
