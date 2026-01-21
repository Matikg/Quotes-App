import SwiftUI

struct SelectBookScreenView: View {
    @StateObject var viewModel = SelectBookScreenViewModel()

    var body: some View {
        BaseView {
            BookListView(books: viewModel.books, showQuotesNumber: false) { book in
                viewModel.selectBook(book: book)
            } onBookDeleted: { _ in }
                .onAppear { viewModel.onAppear() }
                .padding(.horizontal)
        }
        .navBar(center: {
            QText("book_select_screen_navigation_title", type: .bold, size: .medium)
        }, trailing: {
            Button {
                Task { await viewModel.createBook() }
            } label: {
                QText("nav_bar_button_create", type: .regular, size: .small)
            }
        })
    }
}

#Preview {
    SelectBookScreenView()
}
