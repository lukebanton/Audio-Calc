import SwiftUI

struct FieldRow<Field: Hashable, Accessory: View>: View {
    let label: String
    @Binding var text: String
    let field: Field
    @Binding var editingField: Field?
    @Binding var isApplyingDerivedUpdates: Bool
    var keyboard: UIKeyboardType = .decimalPad
    var isLast: Bool = false
    var onChange: ((String) -> Void)?
    @ViewBuilder var accessory: () -> Accessory

    init(
        label: String,
        text: Binding<String>,
        field: Field,
        editingField: Binding<Field?>,
        isApplyingDerivedUpdates: Binding<Bool>,
        keyboard: UIKeyboardType = .decimalPad,
        isLast: Bool = false,
        onChange: ((String) -> Void)? = nil,
        @ViewBuilder accessory: @escaping () -> Accessory = { EmptyView() }
    ) {
        self.label = label
        self._text = text
        self.field = field
        self._editingField = editingField
        self._isApplyingDerivedUpdates = isApplyingDerivedUpdates
        self.keyboard = keyboard
        self.isLast = isLast
        self.onChange = onChange
        self.accessory = accessory
    }

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 4) {
                FieldLabel(title: label)

                TextField("", text: $text)
                    .keyboardType(keyboard)
                    .font(.system(size: AppTheme.fieldValueSize, weight: .medium))
                    .foregroundStyle(AppTheme.primaryText)
                    .textFieldStyle(.plain)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            editingField = field
                        }
                    )
                    .onChange(of: text) { _, newValue in
                        guard !isApplyingDerivedUpdates else { return }
                        if editingField == nil {
                            editingField = field
                        }
                        guard editingField == field else { return }
                        onChange?(newValue)
                    }

                accessory()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 56, alignment: .leading)

            if !isLast {
                FieldHairline()
            }
        }
    }
}

struct ReadOnlyFieldBlock: View {
    let label: String
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(title: label)

            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(.system(size: AppTheme.fieldValueSize, weight: .medium))
                    .foregroundStyle(AppTheme.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56, alignment: .leading)
    }
}

enum CalcFieldSync {
    static func applyDerivedUpdates(_ isApplyingDerivedUpdates: Binding<Bool>, _ updates: () -> Void) {
        isApplyingDerivedUpdates.wrappedValue = true
        updates()
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                isApplyingDerivedUpdates.wrappedValue = false
            }
        }
    }
}
