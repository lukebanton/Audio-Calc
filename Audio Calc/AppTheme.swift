import SwiftUI

enum AppTheme {
    static let groupedBackground = Color(red: 0.949, green: 0.949, blue: 0.969)
    static let cardBackground = Color.white
    static let label = Color(red: 0.557, green: 0.557, blue: 0.576)
    static let primaryText = Color(red: 0.110, green: 0.110, blue: 0.118)
    static let iosBlue = Color(red: 0.0, green: 0.478, blue: 1.0)
    static let hairline = Color(red: 0.898, green: 0.898, blue: 0.918)

    static let cardShadow = Color.black.opacity(0.08)
    static let cardCornerRadius: CGFloat = 16
    static let fieldValueSize: CGFloat = 28
    static let labelSize: CGFloat = 12
}

struct CalcCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
        .shadow(color: AppTheme.cardShadow, radius: 1.5, x: 0, y: 1)
    }
}

struct FieldHairline: View {
    var body: some View {
        Rectangle()
            .fill(AppTheme.hairline)
            .frame(height: 0.5)
            .padding(.leading, 16)
    }
}

struct FieldLabel: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: AppTheme.labelSize, weight: .medium))
            .foregroundStyle(AppTheme.label)
            .tracking(0.5)
    }
}
