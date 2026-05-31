import SwiftUI

enum LatencyDirection {
    case samplesToMilliseconds
    case millisecondsToSamples
}

struct LatencyTabView: View {
    @State private var direction: LatencyDirection = .samplesToMilliseconds
    @State private var is48k = true
    @State private var samples = ""
    @State private var milliseconds = ""
    @State private var isApplyingDerivedUpdates = false

    private var sampleRate: Double {
        is48k ? 48_000 : 96_000
    }

    var body: some View {
        VStack(spacing: 16) {
            CalcCard {
                PillPairToggle(
                    leftTitle: "48k",
                    rightTitle: "96k",
                    isLeftSelected: $is48k,
                    onChange: recalculateOutput
                )
            }

            CalcCard {
                latencyInputRow
                FieldHairline()
                LatencyDirectionSwapButton(action: flipDirection)
                FieldHairline()
                latencyOutputRow
            }
        }
    }

    @ViewBuilder
    private var latencyInputRow: some View {
        switch direction {
        case .samplesToMilliseconds:
            latencyEditableRow(
                label: "Samples",
                text: $samples,
                keyboard: .numberPad,
                onChange: handleInputChange
            )
        case .millisecondsToSamples:
            latencyEditableRow(
                label: "Milliseconds",
                text: $milliseconds,
                keyboard: .decimalPad,
                onChange: handleInputChange
            )
        }
    }

    @ViewBuilder
    private var latencyOutputRow: some View {
        switch direction {
        case .samplesToMilliseconds:
            latencyReadOnlyRow(label: "Milliseconds", value: milliseconds)
        case .millisecondsToSamples:
            latencyReadOnlyRow(label: "Samples", value: samples)
        }
    }

    private func latencyEditableRow(
        label: String,
        text: Binding<String>,
        keyboard: UIKeyboardType,
        onChange: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(title: label)

            TextField("", text: text)
                .keyboardType(keyboard)
                .font(.system(size: AppTheme.fieldValueSize, weight: .medium))
                .foregroundStyle(AppTheme.primaryText)
                .textFieldStyle(.plain)
                .onChange(of: text.wrappedValue) { _, newValue in
                    guard !isApplyingDerivedUpdates else { return }
                    onChange(newValue)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56, alignment: .leading)
    }

    private func latencyReadOnlyRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(title: label)

            Text(value.isEmpty ? "—" : value)
                .font(.system(size: AppTheme.fieldValueSize, weight: .medium))
                .foregroundStyle(value.isEmpty ? AppTheme.label : AppTheme.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56, alignment: .leading)
    }

    private func handleInputChange(_ value: String) {
        switch direction {
        case .samplesToMilliseconds:
            guard FormatHelpers.isIntegerInput(value) else { return }
            if value.isEmpty {
                clearOutput()
                return
            }
            guard let number = Int(value) else { return }
            CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
                milliseconds = FormatHelpers.formatDecimal((Double(number) / sampleRate) * 1000, decimals: 3)
            }
        case .millisecondsToSamples:
            guard let number = FormatHelpers.parseDecimal(value) else {
                if value.isEmpty { clearOutput() }
                return
            }
            CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
                samples = String(Int(round((number / 1000) * sampleRate)))
            }
        }
    }

    private func clearOutput() {
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            switch direction {
            case .samplesToMilliseconds:
                milliseconds = ""
            case .millisecondsToSamples:
                samples = ""
            }
        }
    }

    private func flipDirection() {
        direction = direction == .samplesToMilliseconds ? .millisecondsToSamples : .samplesToMilliseconds
        recalculateOutput()
    }

    private func recalculateOutput() {
        switch direction {
        case .samplesToMilliseconds:
            handleInputChange(samples)
        case .millisecondsToSamples:
            handleInputChange(milliseconds)
        }
    }
}

struct LatencyDirectionSwapButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image(systemName: "arrow.down")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.iosBlue)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.groupedBackground)
                    .clipShape(Circle())
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Switch conversion direction")
    }
}
