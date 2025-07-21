import Foundation
import CoreData
@testable import QuotesApp

enum BookEntityStub {
    static func make(
        id: UUID = UUID(),
        title: String = "Test Title",
        author: String = "Test Author",
        coverImageData: Data? = nil
    ) -> BookEntity {
        // 1) Loading core data model
        let model = NSManagedObjectModel.mergedModel(from: nil)!
        // 2) Fetch the entity descripytion
        let desc = model.entitiesByName["BookEntity"]!
        // 3) Instantiate without a context
        let entity = BookEntity(entity: desc, insertInto: nil)
        
        // 4) Populate its attributes
        entity.id = id
        entity.title = title
        entity.author = author
        entity.coverImage = coverImageData
        
        return entity
    }
}
