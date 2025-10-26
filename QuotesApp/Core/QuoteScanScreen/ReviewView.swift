import SwiftUI
import Vision

private extension CGRect {
    func clamped(to bounds: CGRect) -> CGRect {
        var rect = self

        rect.size.width  = max(40,  min(rect.size.width,  bounds.width))
        rect.size.height = max(40, min(rect.size.height, bounds.height))

        rect.origin.x = min(max(bounds.minX, rect.origin.x), bounds.maxX - rect.size.width)
        rect.origin.y = min(max(bounds.minY, rect.origin.y), bounds.maxY - rect.size.height)

        return rect
    }
}

struct ReviewView: View {
    @ObservedObject private var viewModel: ReviewViewModel
    @State private var cropRect: CGRect = .zero
    
    enum Handle { case top, bottom, left, right }
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        BaseView {
            VStack(spacing: 36) {
                GeometryReader { geo in
                    let size = geo.size
                    let imgSize = viewModel.image.size
                    let safeImgWidth = max(imgSize.width, 1)
                    let safeImgHeight = max(imgSize.height, 1)
                    let scale = min(size.width / safeImgWidth,
                                    size.height / safeImgHeight)
                    let displaySize = CGSize(width: safeImgWidth * scale,
                                             height: safeImgHeight * scale)
                    let xOffset = (size.width - displaySize.width) / 2
                    let yOffset = (size.height - displaySize.height) / 2
                    let imageFrame = CGRect(x: xOffset,
                                            y: yOffset,
                                            width: displaySize.width,
                                            height: displaySize.height)

                    ZStack(alignment: .topLeading) {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: displaySize.width, height: displaySize.height)
                            .offset(x: xOffset, y: yOffset)
                        
                        Path { path in
                            path.addRect(imageFrame)
                            path.addRect(cropRect)
                        }
                        .fill(Color.black.opacity(0.4), style: FillStyle(eoFill: true))
                        
                        CropOverlay(
                            rect: $cropRect,
                            imageFrame: imageFrame,
                            onGestureEnded: {
                                let region = normalized(rect: cropRect, in: size)
                                viewModel.recognizeText(in: region)
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    var newRect = cropRect
                                    newRect.origin.x += value.translation.width
                                    newRect.origin.y += value.translation.height
                                    cropRect = newRect.clamped(to: imageFrame)
                                }
                        )
                    }
                    .onAppear {
                        cropRect = imageFrame
                    }
                    .onChange(of: size) { _, _ in
                        if cropRect == .zero {
                            cropRect = imageFrame
                        } else {
                            cropRect = cropRect.clamped(to: imageFrame)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 35)
                
                recognizedTextBox
            }
            .padding(.top, 30)
        }
        .navBar(center: {
            QText("ScanReview_title", type: .bold, size: .medium)
        }, trailing: {
            Button {
                viewModel.acceptPhoto()
            } label: {
                QText("Save", type: .regular, size: .small)
            }
        })
    }

    // MARK: - Helpers
    
    private func normalized(rect: CGRect, in containerSize: CGSize) -> CGRect {
        let imgSize = viewModel.image.size
        let safeImgWidth = max(imgSize.width, 1)
        let safeImgHeight = max(imgSize.height, 1)
        let scale = min(containerSize.width / safeImgWidth,
                        containerSize.height / safeImgHeight)
        let displaySize = CGSize(width: safeImgWidth * scale,
                                 height: safeImgHeight * scale)
        let xOffset = (containerSize.width - displaySize.width) / 2
        let yOffset = (containerSize.height - displaySize.height) / 2

        let relativeRect = rect
            .offsetBy(dx: -xOffset, dy: -yOffset)

        let x = max(0, relativeRect.minX) / displaySize.width
        let y = 1.0 - (min(displaySize.height, relativeRect.maxY) / displaySize.height)
        let w = relativeRect.width / displaySize.width
        let h = relativeRect.height / displaySize.height

        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    // MARK: - View Builders
    
    private var recognizedTextBox: some View {
        ZStack {
            Rectangle()
                .stroke(.accent, lineWidth: 1)
            
            ScrollView(showsIndicators: false) {
                Text(viewModel.items.map(\.string).joined(separator: " "))
                    .foregroundStyle(.accent)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
            }
        }
        .frame(height: 172)
        .padding(.horizontal, 18)
    }
}

// MARK: - CropOverlay
struct CropOverlay: View {
    @Binding var rect: CGRect
    let imageFrame: CGRect
    let onGestureEnded: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(.accent, lineWidth: 2)
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)
            
            HandleView(handle: .top, rect: $rect, imageFrame: imageFrame, onGestureEnded: onGestureEnded)
                .position(x: rect.midX, y: rect.minY)
            HandleView(handle: .bottom, rect: $rect, imageFrame: imageFrame, onGestureEnded: onGestureEnded)
                .position(x: rect.midX, y: rect.maxY)
            HandleView(handle: .left, rect: $rect, imageFrame: imageFrame, onGestureEnded: onGestureEnded)
                .position(x: rect.minX, y: rect.midY)
            HandleView(handle: .right, rect: $rect, imageFrame: imageFrame, onGestureEnded: onGestureEnded)
                .position(x: rect.maxX, y: rect.midY)
        }
    }
}

// MARK: - HandleView
struct HandleView: View {
    let handle: ReviewView.Handle
    @Binding var rect: CGRect
    let imageFrame: CGRect
    let onGestureEnded: () -> Void

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 20, height: 20)
            .overlay(Circle().stroke(Color.gray))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        var newRect = rect
                        switch handle {
                        case .top:
                            newRect.origin.y    += value.translation.height
                            newRect.size.height -= value.translation.height
                        case .bottom:
                            newRect.size.height += value.translation.height
                        case .left:
                            newRect.origin.x   += value.translation.width
                            newRect.size.width -= value.translation.width
                        case .right:
                            newRect.size.width += value.translation.width
                        }
                        rect = newRect.clamped(to: imageFrame)
                    }
                    .onEnded { _ in
                        onGestureEnded()
                    }
            )
    }
}
