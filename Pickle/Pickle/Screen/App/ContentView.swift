//
//  ContentView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("홈", systemImage: "house")
                    .environment(\.symbolVariants, .none)
            }.tag(0)
            
            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Label("달력", systemImage: "calendar")
                    .environment(\.symbolVariants, .none)
            }.tag(1)
            
            NavigationStack {
                SettingView()
            }
            .tabItem {
                Label("설정", systemImage: "gearshape")
                    .environment(\.symbolVariants, .none)
            }.tag(2)
        }
    }
}

#Preview {
    ContentView()
}
