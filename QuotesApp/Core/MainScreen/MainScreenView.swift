import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        BaseView {
            VStack {
                switch viewModel.state {
                case .empty:
                    buildEmptyListView()

                case let .loaded(books):
                    buildLoadedListView(books: books)
                }
            }
            .onAppear {
                viewModel.getBooks()
            }
        }
        .navBar(
            center: {
                QText("books_screen_navigation_title", type: .bold, size: .medium)
            },
            trailing: {
                Button {
                    viewModel.openSettings()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                }
            }
        )
    }

    // MARK: - View Builders

    private func buildEmptyListView() -> some View {
        VStack {
            Spacer()
            Image(.bookshelf)
                .padding(.bottom, 30)

            QText("main_screen_empty_quotes_dialog", type: .bold, size: .medium)

            QButton(label: "button_add_quote", state: viewModel.buttonState) {
                Task { await viewModel.addQuote() }
            }

            Spacer()
        }
    }

    private func buildLoadedListView(books: [Domain.BookItem]) -> some View {
        VStack(spacing: 0) {
            if viewModel.shouldShowUpdateBanner {
                QBanner(
                    title: "banner_update_title",
                    description: "banner_update_description",
                    action: viewModel.openWhatsNew,
                    onClose: viewModel.dismissUpdateBanner
                )
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }

            BookListView(
                books: books,
                showQuotesNumber: true,
                topInset: 0
            ) { selectedBook in
                viewModel.selectBook(selectedBook)
            } onBookDeleted: { book in
                viewModel.bookToDelete = book
            }
            .refreshable {
                viewModel.getBooks()
            }

            QButton(label: "button_add_quote", state: viewModel.buttonState) {
                Task { await viewModel.addQuote() }
            }
        }
        .alert(item: $viewModel.bookToDelete) { book in
            Alert(
                title: Text("alert_book_delete_title"),
                message: Text("alert_book_delete_message"),
                primaryButton: .destructive(Text("alert_action_delete"), action: {
                    viewModel.deleteBook(book)
                }),
                secondaryButton: .cancel {
                    viewModel.cancelDeleteBook()
                }
            )
        }
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
