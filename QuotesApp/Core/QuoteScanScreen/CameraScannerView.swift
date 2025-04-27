//
//  CameraScannerView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import SwiftUI

struct CameraScannerView: View {
    var body: some View {
        LiveScannerView()
            .ignoresSafeArea(edges: .all)
    }
}
