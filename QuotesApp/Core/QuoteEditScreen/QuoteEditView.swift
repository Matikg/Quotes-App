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
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    QText("Quote_label", type: .bold, size: .vsmall)
                    
                    TextEditor(text: Binding(
                        get: { viewModel.quoteInput ?? "" },
                        set: { newValue in viewModel.quoteInput = newValue.isEmpty ? nil : newValue }
                    ))
                    .font(.custom("Merriweather-Regular", size: 12))
                    .frame(height: 162)
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 10)
                    .background(Rectangle().stroke(viewModel.showError ? .red : .accentColor, lineWidth: 1))
                    
                    if viewModel.showError {
                        QText("Quote_empty_dialog", type: .regular, size: .vsmall)
                            .accentColor(.red)
                    }
                }
                
                VStack(alignment: .leading) {
                    QText("Book_label", type: .bold, size: .vsmall)
                    
                    HStack {
                        TextField("", text: $viewModel.bookInput)
                            .font(.custom("Merriweather-Regular", size: 12))
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.accent)
                            .font(.system(size: 22))
                    }
                    .frame(height: 38)
                    .padding(.horizontal, 10)
                    .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
                }
                
                QTextField("Category_label", input: $viewModel.categoryInput)
                
                QTextField("Page_label", input: $viewModel.pageInput)
                    .keyboardType(.numberPad)
                
                VStack(alignment: .leading) {
                    QText("Note_label", type: .bold, size: .vsmall)
                    
                    TextEditor(text: $viewModel.noteInput)
                        .font(.custom("Merriweather-Regular", size: 12))
                        .frame(height: 162)
                        .scrollContentBackground(.hidden)
                        .padding(.leading, 10)
                        .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
                }
            }
            .padding()
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
    }
}

#Preview {
    QuoteEditView()
}
