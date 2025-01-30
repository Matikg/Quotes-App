import Foundation

protocol AddBookRepositoryInterface {
    var savedBookTitle: String? { get }
    func saveBook(with title: String)
}

final class AddBookRepository: AddBookRepositoryInterface {
    // tutaj bedziemy mogli trzymac ID, albo cala wybrana przez uzytkownika ksiazke.
    var savedBookTitle: String?
    
    func saveBook(with title: String) {
        savedBookTitle = title
    }
}
