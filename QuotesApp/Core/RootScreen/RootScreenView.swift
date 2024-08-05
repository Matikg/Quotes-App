//
//  RootScreenView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

struct RootScreenView: View {
    @ObservedObject var viewModel: RootScreenViewModel
    
    var body: some View {
        if viewModel.isFirstLaunch {
            WelcomeScreenView(viewModel: WelcomeScreenViewModel())
        }
        else {
            MainScreenView(viewModel: MainScreenViewModel())
        }
    }
}

#Preview {
    RootScreenView(viewModel: RootScreenViewModel())
}
