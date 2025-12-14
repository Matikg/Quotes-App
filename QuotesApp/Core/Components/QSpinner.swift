import SwiftUI

struct QSpinner: View {
    var body: some View {
        MaterialSpinner(isLoading: .constant(true))
    }
}

struct SpinnerShape: Shape {
    var start: CGFloat
    var end: CGFloat
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(start, end) }
        set {
            start = newValue.first
            end = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: .degrees(Double(start) * 360),
            endAngle: .degrees(Double(end) * 360),
            clockwise: true
        )
        return path
    }
}

struct MaterialSpinner: View {
    @State private var start: CGFloat = 0.05
    @State private var end: CGFloat = 0.0
    @State private var rotation: Double = 0.0
    @Binding var isLoading: Bool

    var body: some View {
        SpinnerShape(start: start, end: end)
            .stroke(
                Color.accent,
                style: StrokeStyle(lineWidth: 5.5, lineCap: .butt)
            )
            .frame(width: 45, height: 45)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                animateRotation()
                animateHeadTail()
            }
    }

    private func animateRotation() {
        withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }

    private func animateHeadTail() {
        Task {
            while isLoading {
                await animate { start += 0.75 }
                await animate { end += 0.75 }
            }
        }
    }

    private func animate(_ action: @escaping () -> Void) async {
        withAnimation(.easeOut(duration: 0.65)) {
            action()
        }
        try? await Task.sleep(nanoseconds: 650_000_000)
    }
}

#Preview {
    QSpinner()
}
