//
//  ContentView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    var healthKitStore: HealthKitStore = HealthKitStore()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("홈", systemImage: "house")
                    .environment(\.symbolVariants, .fill)
            }.tag(0)
            
            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Label("달력", systemImage: "calendar")
                    .environment(\.symbolVariants, .fill)
            }.tag(1)
            
            NavigationStack {
                SettingView()
            }
            .tabItem {
                Label("설정", systemImage: "gearshape")
                    .environment(\.symbolVariants, .fill)
            }
            .tag(2)
        }
        .onAppear {
            healthKitStore.requestAuthorization { success in
                if success {
                    healthKitStore.fetchStepCount()
                }
            }
        }
        .fullScreenCover(isPresented: $isOnboardingViewActive) {
            SetNotiView(isShowingOnboarding: $isOnboardingViewActive)
        }
        .tint(.pickle)
    }
}

#Preview {
    ContentView()
        .environmentObject(TodoStore())
        .environmentObject(MissionStore())
}
