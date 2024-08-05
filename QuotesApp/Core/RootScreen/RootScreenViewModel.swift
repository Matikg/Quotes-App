//
//  RootScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

final class RootScreenViewModel: ObservableObject {
    @AppStorage(UserDefaultsConstants.FirstLaunchKey) var isFirstLaunch: Bool = true
}
