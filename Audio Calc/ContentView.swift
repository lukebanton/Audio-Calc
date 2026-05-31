import SwiftUI

enum AppTab: CaseIterable {
    case distance, latency, frames

    var title: String {
        switch self {
        case .distance: "Distance"
        case .latency: "Latency"
        case .frames: "Frames"
        }
    }

    var icon: String {
        switch self {
        case .distance: "ruler"
        case .latency: "timer"
        case .frames: "film"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22, weight: selectedTab == tab ? .semibold : .regular))
                        Text(tab.title)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selectedTab == tab ? AppTheme.iosBlue : AppTheme.label)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 80)
        .background(AppTheme.cardBackground)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppTheme.hairline)
                .frame(height: 0.5)
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .distance

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    switch selectedTab {
                    case .distance:
                        DistanceTabView()
                    case .latency:
                        LatencyTabView()
                    case .frames:
                        FramesTabView()
                    }
                }
                .padding(16)
                .padding(.bottom, 16)
            }

            CustomTabBar(selectedTab: $selectedTab)
        }
        .background(AppTheme.groupedBackground)
    }
}

#Preview {
    ContentView()
}
