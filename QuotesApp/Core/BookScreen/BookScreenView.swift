//
//  BookScreenView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import SwiftUI

struct BookScreenView: View {
    @ObservedObject var viewModel = BookScreenViewModel()
    
    var body: some View {
        BackgroundStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Image(.defaultBookCover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 124, height: 169)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        QInput(label: "Title_label", text: $viewModel.titleInput, type: .oneLine, error: viewModel.errors[.title])
                        
                        QInput(label: "Author_label", text: $viewModel.authorInput, type: .oneLine, error: viewModel.errors[.author])
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                QText("BookScreen_title", type: .bold, size: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.saveBook()
                } label: {
                    Text("Save")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background, for: .navigationBar)
    }
}

#Preview {
    BookScreenView()
}
