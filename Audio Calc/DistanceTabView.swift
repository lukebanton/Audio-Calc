import SwiftUI

private enum DistanceField: Hashable {
    case metres, feet, milliseconds
}

struct DistanceTabView: View {
    private let speedOfSound = 343.0
    private let metresPerFoot = 0.3048

    @State private var editingField: DistanceField?
    @State private var isApplyingDerivedUpdates = false
    @State private var metres = ""
    @State private var feet = ""
    @State private var milliseconds = ""

    var body: some View {
        VStack(spacing: 16) {
            CalcCard {
                FieldRow(
                    label: "Metres",
                    text: $metres,
                    field: .metres,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    onChange: handleMetresChange
                )
                FieldRow(
                    label: "Feet",
                    text: $feet,
                    field: .feet,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    onChange: handleFeetChange
                )
                FieldRow(
                    label: "Milliseconds",
                    text: $milliseconds,
                    field: .milliseconds,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    isLast: true,
                    onChange: handleMillisecondsChange
                )
            }

            Text("Speed of sound: 343 m/s at 20°C")
                .font(.system(size: 12))
                .foregroundStyle(AppTheme.label)
                .frame(maxWidth: .infinity)
                .padding(.top, -8)
        }
    }

    private func clearAll() {
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            metres = ""
            feet = ""
            milliseconds = ""
        }
    }

    private func handleMetresChange(_ value: String) {
        guard let number = FormatHelpers.parseDecimal(value) else {
            if value.isEmpty { clearAll() }
            return
        }
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            feet = FormatHelpers.formatDecimal(number / metresPerFoot, decimals: 3)
            milliseconds = FormatHelpers.formatDecimal((number / speedOfSound) * 1000, decimals: 2)
        }
    }

    private func handleFeetChange(_ value: String) {
        guard let number = FormatHelpers.parseDecimal(value) else {
            if value.isEmpty { clearAll() }
            return
        }
        let m = number * metresPerFoot
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            metres = FormatHelpers.formatDecimal(m, decimals: 3)
            milliseconds = FormatHelpers.formatDecimal((m / speedOfSound) * 1000, decimals: 2)
        }
    }

    private func handleMillisecondsChange(_ value: String) {
        guard let number = FormatHelpers.parseDecimal(value) else {
            if value.isEmpty { clearAll() }
            return
        }
        let m = (number / 1000) * speedOfSound
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            metres = FormatHelpers.formatDecimal(m, decimals: 3)
            feet = FormatHelpers.formatDecimal(m / metresPerFoot, decimals: 3)
        }
    }
}
