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
        let _ = RealmMigrator()
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
    
    // Launch Screen Delay
    init() {
        Thread.sleep(forTimeInterval: 2)
    }
    
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
                        print("backgroundTimeStemp: \(timerVM.backgroundTimeStemp)")
                        timerVM.fromBackground = true
                    }
                    if newScene == .active {
                        print("ACTIVE")
                        
                        if timerVM.fromBackground {
                            
                            timerVM.makeRandomSaying()
                            print("\(timerVM.wiseSaying)")
                            
                            print("backgroundTimeStemp: \(timerVM.backgroundTimeStemp)")
                            
                            var currentTime: Date = Date()
                            print("currentTime:\(currentTime) / Date(): \(Date())")
                            
                            var diff = currentTime.timeIntervalSince(timerVM.backgroundTimeStemp)
                            print("diff: \(TimeInterval(diff))")
                            
                            print("timeRemaining: \(timerVM.timeRemaining)")
                            
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
                            timerVM.fromBackground = false
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
        missionStore.deleteAll(mission: .behavior(.init()))
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
