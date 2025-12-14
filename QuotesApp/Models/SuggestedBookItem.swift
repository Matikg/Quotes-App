import Foundation

extension Domain {
    // swiftlint:disable nesting
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
    // swiftlint: enable nesting
}

extension Domain.SuggestedBookItem {
    init?(model: BookDoc) {
        guard let title = model.title else { return nil }
        self.title = title
        author = model.authorName?.joined(separator: ", ") ?? ""
        coverImageData = nil

        if let editionKey = model.coverEditionKey, let url = URL(string: "https://covers.openlibrary.org/b/olid/\(editionKey)-M.jpg?default=false") {
            cover = .remote(url)
        } else if let coverKey = model.coverKey, let url = URL(string: "https://covers.openlibrary.org/b/id/\(coverKey)-M.jpg?default=false") {
            cover = .remote(url)
        } else {
            cover = .default
        }
    }
}
