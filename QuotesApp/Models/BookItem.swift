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
        quotesNumber = bookEntity.quotes?.count ?? 0
        coverImageData = bookEntity.coverImage
    }
}

extension Domain.BookItem {
    init(from suggestedBook: Domain.SuggestedBookItem) {
        id = suggestedBook.id
        title = suggestedBook.title
        author = suggestedBook.author
        quotesNumber = 0
        coverImageData = suggestedBook.coverImageData
    }
}
