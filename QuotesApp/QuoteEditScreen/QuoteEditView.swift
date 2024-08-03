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
        Text("Quote Edit")
    }
}

#Preview {
    QuoteEditView()
}
