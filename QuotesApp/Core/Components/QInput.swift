import SwiftUI

struct QInput: View {
    enum InputType {
        case oneLine
        case multiLine
    }

    @Binding private var text: String
    private let label: String
    private let inputType: InputType
    private let isLoading: Bool
    private let error: String?

    init(
        label: String,
        text: Binding<String>,
        type: InputType,
        isLoading: Bool = false,
        error: String? = nil
    ) {
        self.label = label
        _text = text
        inputType = type
        self.isLoading = isLoading
        self.error = error
    }

    var body: some View {
        VStack(alignment: .leading) {
            QText(label, type: .bold, size: .vsmall)

            switch inputType {
            case .oneLine:
                HStack {
                    TextField("", text: $text)
                        .font(.custom("Merriweather-Regular", size: 12))
                        .foregroundStyle(.accent)

                    if isLoading {
                        QSpinner().scaleEffect(0.4)
                    }
                }
                .frame(height: 38)
                .padding(.leading, 10)
                .background(Rectangle().stroke(error == nil ? .accent : .red, lineWidth: 1))

            case .multiLine:
                TextEditor(text: $text)
                    .font(.custom("Merriweather-Regular", size: 12))
                    .foregroundStyle(.accent)
                    .frame(height: 162)
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 5)
                    .background(Rectangle().stroke(error == nil ? .accent : .red, lineWidth: 1))
            }

            if let error {
                QText(error, type: .regular, size: .vsmall)
                    .accentColor(.red)
            }
        }
    }
}

#Preview {
    VStack {
        QInput(label: "label", text: .constant("text"), type: .oneLine)
            .padding(.bottom, 20)
        QInput(label: "label", text: .constant("text"), type: .oneLine, isLoading: true)
            .padding(.bottom, 20)
        QInput(label: "label", text: .constant("text"), type: .multiLine)
            .padding(.bottom, 20)
    }
}
