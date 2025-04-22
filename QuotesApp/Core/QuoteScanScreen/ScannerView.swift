//
//  ScannerView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/04/2025.
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        CameraView()
    }
}

#Preview {
    ScannerView()
}
