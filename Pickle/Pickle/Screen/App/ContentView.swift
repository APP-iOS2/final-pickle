//
//  ContentView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct ScrollContainer: EnvironmentKey {
    
    static var defaultValue: Binding<ScrollEnableKey> = .constant(.init())
}

struct ScrollEnableKey {
    var root: Bool = false
    var setting: Bool = false
    var calendar: Bool = false
}

extension EnvironmentValues {
    var scrollEnable: Binding<ScrollEnableKey> {
        get { self[ScrollContainer.self] }
        set { self[ScrollContainer.self] = newValue }
    }
}

extension View {
    func scrollEnableInject(_ container: Binding<ScrollEnableKey>) -> some View {
        self.environment(\.scrollEnable, container)
    }
}

struct ContentView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("systemTheme") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    
    @EnvironmentObject var pizzaStore: PizzaStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var missionStore: MissionStore
    @EnvironmentObject var healthKitStore: HealthKitStore
    @EnvironmentObject var navigationStore: NavigationStore
    
    @State private var rootScrollEnable: Bool = false
    @State private var rootScrollEnableKey = ScrollEnableKey(root: false,
                                                             calendar: false)
    
    var selectedScheme: ColorScheme? {
        guard let theme = SchemeType(rawValue: systemTheme) else { return nil }
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            TabView(selection: navigationStore.createTabViewBinding(proxy: proxy,
                                                                    key: $rootScrollEnableKey)) {
                NavigationStack(path: $navigationStore.homeNav) {
                    HomeView()
                }.tabItem {
                    Label("홈", systemImage: "house")
                        .environment(\.symbolVariants, .fill)
                }.tag(TabItem.home)
                
                NavigationStack(path: $navigationStore.calendarNav) {
                    CalendarView()
                        
                }.tabItem {
                    Label("달력", systemImage: "calendar")
                        .environment(\.symbolVariants, .fill)
                }.tag(TabItem.calendar)
                
                NavigationStack {
                   PizzaSummaryView()
                }.tabItem {
                    Label("통계", systemImage: "list.clipboard.fill")
                        .environment(\.symbolVariants, .fill)
                }.tag(TabItem.statistics)
                
                NavigationStack(path: $navigationStore.settingNav) {
                    SettingView()
                }
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                        .environment(\.symbolVariants, .fill)
                }.tag(TabItem.setting)
            }
            .task { /*await pizzaSetting()*/ } // 피자 첫 실행시 로컬에 저장
            .onAppear {
                userSetting()        // UserSetting
                healthKitStore.requestAuthorization { success in
                    if success {
                        healthKitStore.fetchStepCount()
                    }
                }
            }
            .fullScreenCover(isPresented: $isOnboardingViewActive) {
                SettingNotiicationView(isShowingOnboarding: $isOnboardingViewActive)
            }
            .tint(.pickle)
            .preferredColorScheme(selectedScheme)
        }
        .scrollEnableInject($rootScrollEnableKey)
    }
}

extension ContentView {
    
    /// 처음 한번만 실행되는 함수,
    /// 피자를 셋팅하여 아직 열리지 않은 피자는 lock 을 true 로 한다.
    private func pizzaSetting() async {
        let value = await pizzaStore.fetch()
        if !value.isEmpty { return }
        Pizza.allCasePizza.forEach { pizza in
            do {
                try pizzaStore.add(pizza: pizza)
            } catch {
                errorHandler(error)
            }
        }
    }
    
    func userSetting() {
        do {
            try userStore.fetchUser()
        } catch {
            // MARK: Add User Action
            errorHandler(error)
        }
    }
    
    private func errorHandler(_ error: Error) {
        guard let error = error as? PersistentedError else { return }
        if error == .fetchUserError {
            userStore.addUser()
            try! userStore.fetchUser()
        } else if error == .addFaild {
            Log.error("피자를 추가하는 중에 에러 발생")
        } else if error == .fetchError {
            Log.error("페치를 하는 중에 에러 발생")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitStore())
        .environmentObject(MissionStore())
        .environmentObject(NavigationStore(mediator: NotiMediator()))
        .environmentObject(UserStore())
        .environmentObject(PizzaStore())
}
