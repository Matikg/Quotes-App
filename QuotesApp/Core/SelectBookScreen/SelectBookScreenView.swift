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
            QText("BookSelect_title", type: .bold, size: .medium)
        }, trailing: {
            Button {
                viewModel.createBook()
            } label: {
                QText("Create", type: .regular, size: .small)
            }
        })
    }
}

#Preview {
    SelectBookScreenView()
}
