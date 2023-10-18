//
//  ContentView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @EnvironmentObject var pizzaStore: PizzaStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var missionStore: MissionStore
    
    private var healthKitStore: HealthKitStore = HealthKitStore()
    
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
        .task { 
            userSetting()        // UserSetting
            await pizzaSetting() // 피자 첫 실행시 로컬에 저장
            missionSetting()
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
    
    private func userSetting() {
        do {
            try userStore.fetchUser()
        } catch {
            errorHandler(error)
        }
    }
    // 마이그래이션
    // 코어데이터할때도 마이그레이션 어쩌고 데이터변경이 일어나면 ~
    // 배ㅠ포할땐 마이그레이션어쩌고 코드도 넣어서 ? 지금은 그냥 앱삭제 다시깔기
    // 버전이 바뀌면 파일 바뀌니까 그거에 대응해줘야함
    private func missionSetting() {
        let (t,b) = missionStore.fetch()
        if t.isEmpty && b.isEmpty { return }
        if t.isEmpty { 
            let time = TimeMission(title: "기상 미션", status: .done, date: Date(), wakeupTime: Date())
            missionStore.add(mission: .time(time))
        }
        if b.isEmpty {
            let behavior = BehaviorMission(title: "걷기 미션", status: .ready, status2: .ready, status3: .ready, date: Date())
            missionStore.add(mission: .behavior(behavior))
        }
    }
    
    private func errorHandler(_ error: Error) {
        guard let error = error as? PersistentedError else { return }
        if error == .fetchNothing {
            userStore.addUser()
        } else if error == .addFaild {
            Log.error("피자를 추가하는 중에 에러 발생")
        } else if error == .fetchError {
            Log.error("페치를 하는 중에 에러 발생")
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(TodoStore())
        .environmentObject(MissionStore())
}
