//
//  RecognizedTextItem.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import SwiftUI

extension Domain {
    struct RecognizedTextItem: Identifiable, Equatable, Hashable {
        let id = UUID()
        let string: String
        let boundingBox: CGRect
    }
}
