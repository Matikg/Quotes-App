//
//  QuoteEditView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import SwiftUI

struct QuoteEditView: View {
    @ObservedObject var viewModel = QuoteEditViewModel()
    
    var body: some View {
        BackgroundStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading) {
                        QInput(label: "Quote_label", text: $viewModel.quoteInput, type: .multiLine)
                        
                        if viewModel.showError {
                            QText("Quote_empty_dialog", type: .regular, size: .vsmall)
                                .accentColor(.red)
                        }
                    }
                    
                    buildBookButton()
                    
                    QInput(label: "Category_label", text: $viewModel.categoryInput, type: .oneLine)
                    
                    QInput(label: "Page_label", text: $viewModel.pageInput, type: .oneLine)
                        .keyboardType(.numberPad)
                    
                    QInput(label: "Note_label", text: $viewModel.noteInput, type: .multiLine)
                }
                .padding()
            }
            .gesture(
                DragGesture().onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                QText("QuoteEdit_title", type: .bold, size: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.saveQuote()
                } label: {
                    Text("Save")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background, for: .navigationBar)
    }
    
    //MARK: - View Builders
    
    private func buildBookButton() -> some View {
        VStack(alignment: .leading) {
            QText("Book_label", type: .bold, size: .vsmall)
            
            Button {
                //TODO: Navigation to child view
            } label: {
                HStack {
                    Text("Test")
                        .font(.custom("Merriweather-Regular", size: 12))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.accent)
                        .font(.system(size: 22))
                }
                .frame(height: 38)
                .padding(.horizontal, 10)
                .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
            }
        }
    }
}

#Preview {
    QuoteEditView()
}
