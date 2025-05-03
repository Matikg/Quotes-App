//
//  ReviewView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject var viewModel: ReviewViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let container = geo.size
                let imgSize = viewModel.image.size
                let scale = min(
                    container.width / imgSize.width,
                    container.height / imgSize.height
                )
                let displayS = CGSize(
                    width: imgSize.width * scale,
                    height: imgSize.height * scale
                )
                let xOffset = (container.width - displayS.width) / 2
                let yOffset = (container.height - displayS.height) / 2
                
                ZStack(alignment: .topLeading) {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: displayS.width, height: displayS.height)
                    
                    ForEach(viewModel.items) { item in
                        let box = item.boundingBox
                        let x = box.minX * displayS.width
                        let y = (1 - box.maxY) * displayS.height
                        let width = box.width  * displayS.width
                        let height = box.height * displayS.height
                        
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: width, height: height)
                            .offset(x: x, y: y)
                    }
                }
                .offset(x: xOffset, y: yOffset)
            }
            .frame(height: 400)
            
            Divider()
            
            ScrollView {
                Text(viewModel.items.map(\.string).joined(separator: " "))
                    .padding()
                    .textSelection(.enabled)
            }
            .layoutPriority(1)
            
            Divider()
            
            HStack {
                Button("Retake_button_label", action: viewModel.retakePhoto).padding()
                Spacer()
                Button("Done_button_label", action: viewModel.acceptPhoto).padding()
            }
        }
    }
}
