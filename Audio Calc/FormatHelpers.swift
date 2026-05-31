import Foundation

enum FormatHelpers {
    static func parseDecimal(_ value: String) -> Double? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty || trimmed == "-" { return nil }
        return Double(trimmed)
    }

    static func formatDecimal(_ value: Double, decimals: Int) -> String {
        String(format: "%.\(decimals)f", value)
    }

    static func formatIntegerWithCommas(_ value: Double) -> String {
        let rounded = Int(round(value))
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: rounded)) ?? "\(rounded)"
    }

    static func isIntegerInput(_ value: String) -> Bool {
        value.isEmpty || value.allSatisfy(\.isNumber)
    }
}
