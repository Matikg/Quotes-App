import DependencyInjection
@testable import QuotesApp
import XCTest

@MainActor
final class BookScreenViewModelTests: XCTestCase {
    private var mockNavigationRouter: MockNavigationRouter!
    private var mockSaveQuoteRepo: MockSaveQuoteRepository!
    private var mockCrashlyticsManager: MockCrashlyticsManager!

    private var sut: BookScreenViewModel!

    override func setUp() {
        super.setUp()

        mockNavigationRouter = MockNavigationRouter()
        mockSaveQuoteRepo = MockSaveQuoteRepository()
        mockCrashlyticsManager = MockCrashlyticsManager()

        let container = ContainerManager.shared.container(for: .main)
        container.reset()
        container.register((any NavigationRouting).self, instance: mockNavigationRouter)
        container.register(SaveQuoteRepositoryInterface.self, instance: mockSaveQuoteRepo)
        container.register(CrashlyticsManagerInterface.self, instance: mockCrashlyticsManager)
        container.register(BookApiService.self, instance: BookApiService(session: MockNetworkSession()))

        sut = BookScreenViewModel()
    }

    override func tearDown() {
        ContainerManager.shared.removeContainer(for: .main)
        mockNavigationRouter = nil
        mockSaveQuoteRepo = nil
        mockCrashlyticsManager = nil
        sut = nil
        super.tearDown()
    }

    func test_handleCoverSelectionLoad_updatesSelectedBookCoverData() async {
        // Given
        let previousCover = Data([9, 8, 7])
        let loadedCover = Data([1, 2, 3])
        sut.selectedBook = Domain.SuggestedBookItem(
            title: "Book",
            author: "Author",
            cover: .default,
            coverImageData: previousCover
        )

        // When
        await sut.handleCoverSelectionLoad {
            loadedCover
        }

        // Then
        XCTAssertEqual(sut.coverImage.imageData, loadedCover)
        XCTAssertEqual(sut.selectedBook?.coverImageData, loadedCover)
    }

    func test_handleCoverSelectionLoad_keepsCurrentCoverWhenLoadingFails() async {
        // Given
        let existingCover = Data([4, 5, 6])
        sut.setManualCover(data: existingCover)

        // When
        await sut.handleCoverSelectionLoad {
            throw URLError(.badServerResponse)
        }

        // Then
        XCTAssertEqual(sut.coverImage.imageData, existingCover)
    }

    func test_resetCover_clearsSelectedBookCoverData() {
        // Given
        let existingCover = Data([4, 5, 6])
        sut.selectedBook = Domain.SuggestedBookItem(
            title: "Book",
            author: "Author",
            cover: .default,
            coverImageData: existingCover
        )
        sut.setManualCover(data: existingCover)

        // When
        sut.resetCover()

        // Then
        XCTAssertNil(sut.coverImage.imageData)
        XCTAssertNil(sut.selectedBook?.coverImageData)
    }

    func test_saveBook_prefersManualCoverOverSelectedBookCover() {
        // Given
        let suggestedCover = Data([7, 7, 7])
        let manualCover = Data([1, 1, 1])
        sut.titleInput = "Book"
        sut.authorInput = "Author"
        sut.selectedBook = Domain.SuggestedBookItem(
            title: "Book",
            author: "Author",
            cover: .default,
            coverImageData: suggestedCover
        )
        sut.setManualCover(data: manualCover)

        // When
        sut.saveBook()

        // Then
        XCTAssertEqual(mockSaveQuoteRepo.selectBookCalledWith?.coverImageData, manualCover)
        XCTAssertEqual(mockNavigationRouter.popCallCount, 1)
    }
}
