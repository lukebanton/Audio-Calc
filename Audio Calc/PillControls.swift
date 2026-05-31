import SwiftUI

struct PillPairToggle: View {
    let leftTitle: String
    let rightTitle: String
    @Binding var isLeftSelected: Bool
    var onChange: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            pillButton(title: leftTitle, selected: isLeftSelected) {
                isLeftSelected = true
                onChange?()
            }
            pillButton(title: rightTitle, selected: !isLeftSelected) {
                isLeftSelected = false
                onChange?()
            }
        }
        .padding(12)
    }

    private func pillButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundStyle(selected ? .white : AppTheme.label)
                .background(selected ? AppTheme.iosBlue : Color.clear)
                .clipShape(Capsule())
                .overlay {
                    if !selected {
                        Capsule()
                            .stroke(AppTheme.hairline, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

struct InlinePillPairToggle: View {
    @Binding var is48kSelected: Bool
    var onChange: (() -> Void)?

    var body: some View {
        HStack(spacing: 6) {
            inlinePill(title: "48k", selected: is48kSelected) {
                is48kSelected = true
                onChange?()
            }
            inlinePill(title: "96k", selected: !is48kSelected) {
                is48kSelected = false
                onChange?()
            }
        }
        .padding(.top, 8)
    }

    private func inlinePill(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .foregroundStyle(selected ? .white : AppTheme.label)
                .background(selected ? AppTheme.iosBlue : Color.clear)
                .clipShape(Capsule())
                .overlay {
                    if !selected {
                        Capsule()
                            .stroke(AppTheme.hairline, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

struct FPSSelector: View {
    let options: [Double]
    @Binding var selectedFPS: Double
    var onChange: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(title: "Frame Rate")

            Picker("", selection: $selectedFPS) {
                ForEach(options, id: \.self) { fps in
                    Text(fpsLabel(fps)).tag(fps)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .font(.system(size: AppTheme.fieldValueSize, weight: .medium))
            .foregroundStyle(AppTheme.primaryText)
            .tint(AppTheme.iosBlue)
            .onChange(of: selectedFPS) { _, _ in
                onChange?()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 56, alignment: .leading)
    }

    private func fpsLabel(_ fps: Double) -> String {
        fps.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", fps)
            : String(fps)
    }
}
