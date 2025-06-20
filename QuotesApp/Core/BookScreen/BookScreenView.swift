//
//  BookScreenView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import SwiftUI

struct BookScreenView: View {
    @StateObject var viewModel = BookScreenViewModel()
    
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    buildBookCover()
                    
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(spacing: 0) {
                            QInput(
                                label: "Title_label",
                                text: $viewModel.titleInput,
                                type: .oneLine,
                                error: viewModel.errors[.title]
                            )
                            .editing($viewModel.isTitleEditing)
                            .autocorrectionDisabled()
                            
                            buildBookHint()
                        }
                        
                        QInput(label: "Author_label", text: $viewModel.authorInput, type: .oneLine, error: viewModel.errors[.author])
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navBar(center: {
            QText("BookScreen_title", type: .bold, size: .medium)
        }, trailing: {
            Button {
                viewModel.saveBook()
            } label: {
                QText("Save", type: .regular, size: .small)
            }
        })
    }
    
    //MARK: - View Builders
    
    @ViewBuilder
    private func buildBookCover() -> some View {
        switch viewModel.coverImage {
        case .default:
            DefaultBookCover()
        case .loading:
            ProgressView()
                .tint(.accent)
                .frame(width: 124, height: 169)
        case .image(let data):
            if let uiImage = UIImage(data: data) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 124, height: 169)
                    
                    Button(action: {
                        viewModel.resetCover()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.accent)
                            .padding(4)
                            .background(Color.background)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .offset(x: 0, y: -8)
                }
            } else {
                DefaultBookCover()
            }
        }
    }
    
    @ViewBuilder
    private func buildBookHint() -> some View {
        if !viewModel.foundBooks.isEmpty, !viewModel.titleInput.isEmpty {
            VStack(spacing: 0) {
                ForEach(viewModel.foundBooks.prefix(3)) { book in
                    QText("\(book.title), \(book.author)", type: .bold, size: .vsmall)
                        .padding(.leading, 20)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.hint)
                        .lineLimit(1)
                        .onTapGesture {
                            viewModel.selectBook(book)
                        }
                }
            }
        }
    }
}

#Preview {
    BookScreenView()
}
