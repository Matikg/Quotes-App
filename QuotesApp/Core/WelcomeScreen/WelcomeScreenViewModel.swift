//
//  WelcomeScreenViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 10/07/2024.
//

import SwiftUI

final class WelcomeScreenViewModel: ObservableObject {
    func ctaButtonTapped() {
        UserDefaults.standard.setValue(false, forKey: UserDefaultsConstants.FirstLaunchKey)
    }
}
