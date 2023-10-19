//
//  PickleApp.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        PickleApp.setUpDependency()
       
        return true
    }
}

@main
struct PickleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var todoStore = TodoStore()
    @StateObject private var missionStore = MissionStore()
    @StateObject private var userStore = UserStore()
    @StateObject private var pizzaStore = PizzaStore()
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var timerVM = TimerViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "__UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
            ContentView()
                .environmentObject(todoStore)
                .environmentObject(missionStore)
                .environmentObject(userStore)
                .environmentObject(notificationManager)
                .environmentObject(pizzaStore)
                .environmentObject(timerVM)
                .onChange(of: scenePhase) { newScene in
                    if newScene == .background {
                        print("BACKGROUD")
                        
                        timerVM.backgroundTimeStemp = Date()
                        // 유저디폴트같은데서.......저장해주기
                    }
                    if newScene == .active {
                        print("ACTIVE")
                        
                        var diff = Date().timeIntervalSince(timerVM.backgroundTimeStemp)
                        print("\(TimeInterval(diff))")
                        print("\(timerVM.timeRemaining)")
                        print("\(timerVM.timeRemaining > diff)")
                        
                        timerVM.spendTime += diff
                        
                        if timerVM.timeRemaining > 0 {
                            if timerVM.timeRemaining > diff {
                                timerVM.timeRemaining -= diff
                            } else {
                                diff -= timerVM.timeRemaining
                                timerVM.isDecresing = false
                                timerVM.timeExtra += diff
                            }
                        } else {
                            timerVM.timeExtra += diff
                        }
                        
                    }
                    
                }
        }
       
    }
    
    /// 테스트용
    private func dummyDelete() {
        Log.debug("dummy Delete called")
        userStore.deleteuserAll()
        missionStore.deleteAll(mission: .time(.init()))
        missionStore.deleteAll(mission: .behavior(.init(status2: .complete, status3: .complete)))
        pizzaStore.deleteAll()
        Log.debug("dummy Delete end")
    }
}

extension PickleApp {
    
    static func setUpDependency() {
        DependencyContainer.register(DBStoreKey.self, RealmStore())
        DependencyContainer.register(TodoRepoKey.self, TodoRepository())
        DependencyContainer.register(BehaviorRepoKey.self, BehaviorMissionRepository())
        DependencyContainer.register(TimeRepoKey.self, TimeMissionRepository())
        DependencyContainer.register(UserRepoKey.self, UserRepository())
        DependencyContainer.register(PizzaRepoKey.self, PizzaRepository())
    }
}
