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
    @State private var isCropVisible: Bool = false
    @State private var cropRect: CGRect = .zero
    @State private var activeHandle: Handle? = nil

    enum Handle { case top, bottom, left, right }
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let size = geo.size
                let imgSize = viewModel.image.size
                let scale = min(size.width / imgSize.width,
                                size.height / imgSize.height)
                let displaySize = CGSize(width: imgSize.width * scale,
                                         height: imgSize.height * scale)
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

                    if isCropVisible {
                        Path { path in
                            path.addRect(imageFrame)
                            path.addRect(cropRect)
                        }
                        .fill(Color.black.opacity(0.4), style: FillStyle(eoFill: true))
                    }

                    if isCropVisible {
                        CropOverlay(
                            rect: $cropRect,
                            imageFrame: imageFrame
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

                    Button(action: { toggleCrop() }) {
                        Image(systemName: "crop")
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Circle().fill(Color.black))
                    }
                    .padding()
                    .position(x: size.width - 30, y: 30)

                    if isCropVisible {
                        Button(action: {
                            let region = normalized(rect: cropRect, in: size)
                            viewModel.recognizeText(in: region)
                            isCropVisible = false
                        }) {
                            Text("Find_button_label")
                                .padding(8)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        .position(x: size.width - 50, y: 70)
                    }
                }
                .onAppear {
                    cropRect = imageFrame
                }
            }
            .frame(height: 400)

            Divider()

            ScrollView {
                Text(viewModel.items.map(\.string).joined(separator: " "))
                    .foregroundStyle(Color.accentColor)
                    .padding()
                    .textSelection(.enabled)
            }
            .layoutPriority(1)

            Divider()
            HStack {
                Button("Retake_button_label") { viewModel.retakePhoto() }
                    .padding()
                Spacer()
                Button("Done_button_label") { viewModel.acceptPhoto() }
                    .padding()
            }
        }
        .background(Color.background)
    }

    // MARK: - Helpers

    private func toggleCrop() {
        isCropVisible.toggle()
    }

    private func normalized(rect: CGRect, in containerSize: CGSize) -> CGRect {
        let imgSize = viewModel.image.size
        let scale = min(containerSize.width / imgSize.width,
                        containerSize.height / imgSize.height)
        let displaySize = CGSize(width: imgSize.width * scale,
                                 height: imgSize.height * scale)
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
}

// MARK: - CropOverlay
struct CropOverlay: View {
    @Binding var rect: CGRect
    let imageFrame: CGRect

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)

            HandleView(handle: .top, rect: $rect, imageFrame: imageFrame)
                .position(x: rect.midX, y: rect.minY)
            HandleView(handle: .bottom, rect: $rect, imageFrame: imageFrame)
                .position(x: rect.midX, y: rect.maxY)
            HandleView(handle: .left, rect: $rect, imageFrame: imageFrame)
                .position(x: rect.minX, y: rect.midY)
            HandleView(handle: .right, rect: $rect, imageFrame: imageFrame)
                .position(x: rect.maxX, y: rect.midY)
        }
    }
}

// MARK: - HandleView
struct HandleView: View {
    let handle: ReviewView.Handle
    @Binding var rect: CGRect
    let imageFrame: CGRect

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
            )
    }
}
