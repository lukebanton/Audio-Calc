import SwiftUI

private enum FramesField: Hashable {
    case frames, milliseconds, samples
}

struct FramesTabView: View {
    private let fpsOptions: [Double] = [
        23.976, 24, 25, 29.97, 30, 47.952, 48, 50, 59.94, 60
    ]

    @State private var editingField: FramesField?
    @State private var isApplyingDerivedUpdates = false
    @State private var fps = 25.0
    @State private var is48k = true
    @State private var frames = ""
    @State private var milliseconds = ""
    @State private var samples = ""

    private var sampleRate: Double {
        is48k ? 48_000 : 96_000
    }

    var body: some View {
        VStack(spacing: 16) {
            CalcCard {
                FPSSelector(options: fpsOptions, selectedFPS: $fps, onChange: recalculateForFPSChange)
            }

            CalcCard {
                FieldRow(
                    label: "Frames",
                    text: $frames,
                    field: .frames,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    keyboard: .numberPad,
                    onChange: handleFramesChange
                )
                FieldRow(
                    label: "Milliseconds",
                    text: $milliseconds,
                    field: .milliseconds,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    onChange: handleMillisecondsChange
                )
                FieldRow(
                    label: "Samples",
                    text: $samples,
                    field: .samples,
                    editingField: $editingField,
                    isApplyingDerivedUpdates: $isApplyingDerivedUpdates,
                    keyboard: .numberPad,
                    isLast: true,
                    onChange: handleSamplesChange
                ) {
                    InlinePillPairToggle(is48kSelected: $is48k, onChange: recalculateForSampleRateChange)
                }
            }
        }
    }

    private func clearAll() {
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            frames = ""
            milliseconds = ""
            samples = ""
        }
    }

    private func handleFramesChange(_ value: String) {
        guard FormatHelpers.isIntegerInput(value) else { return }
        if value.isEmpty {
            clearAll()
            return
        }
        guard let number = Int(value) else { return }
        let ms = (Double(number) / fps) * 1000
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            milliseconds = FormatHelpers.formatDecimal(ms, decimals: 3)
            samples = String(Int(round((ms / 1000) * sampleRate)))
        }
    }

    private func handleMillisecondsChange(_ value: String) {
        guard let number = FormatHelpers.parseDecimal(value) else {
            if value.isEmpty { clearAll() }
            return
        }
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            frames = String(Int(round((number / 1000) * fps)))
            samples = String(Int(round((number / 1000) * sampleRate)))
        }
    }

    private func handleSamplesChange(_ value: String) {
        guard FormatHelpers.isIntegerInput(value) else { return }
        if value.isEmpty {
            clearAll()
            return
        }
        guard let number = Int(value) else { return }
        let ms = (Double(number) / sampleRate) * 1000
        CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
            milliseconds = FormatHelpers.formatDecimal(ms, decimals: 3)
            frames = String(Int(round((ms / 1000) * fps)))
        }
    }

    private func recalculateForFPSChange() {
        recalculate(from: editingField ?? .frames)
    }

    private func recalculateForSampleRateChange() {
        recalculate(from: editingField ?? .frames)
    }

    private func recalculate(from source: FramesField) {
        switch source {
        case .frames:
            guard let number = Int(frames) else { break }
            let ms = (Double(number) / fps) * 1000
            CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
                milliseconds = FormatHelpers.formatDecimal(ms, decimals: 3)
                samples = String(Int(round((ms / 1000) * sampleRate)))
            }
        case .milliseconds:
            guard let number = FormatHelpers.parseDecimal(milliseconds) else { break }
            CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
                frames = String(Int(round((number / 1000) * fps)))
                samples = String(Int(round((number / 1000) * sampleRate)))
            }
        case .samples:
            guard let number = Int(samples) else { break }
            let ms = (Double(number) / sampleRate) * 1000
            CalcFieldSync.applyDerivedUpdates($isApplyingDerivedUpdates) {
                milliseconds = FormatHelpers.formatDecimal(ms, decimals: 3)
                frames = String(Int(round((ms / 1000) * fps)))
            }
        }
    }
}
