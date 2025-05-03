//
//  ReviewViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import Foundation
import DependencyInjection
import SwiftUI

final class ReviewViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveScannedQuoteRepository: SaveScannedQuoteRepositoryInterface
    
    let image: UIImage
    let items: [Domain.RecognizedTextItem]
    
    init(image: UIImage, items: [Domain.RecognizedTextItem]) {
        self.image = image
        self.items = items
    }
    
    func retakePhoto() {
        navigationRouter.pop()
    }
    
    func acceptPhoto() {
        saveScannedQuoteRepository.saveScannedQuote(items.map { $0.string }.joined(separator: " "))
        
        navigationRouter.pop()
        navigationRouter.pop()
    }
}
