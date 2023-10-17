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
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "__UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            ContentView()
                .task {
                    try? await userStore.fetchUser()
                }
                .environmentObject(todoStore)
                .environmentObject(missionStore)
                .environmentObject(userStore)
                .environmentObject(notificationManager)
        }
    }
}

extension PickleApp {
    
    static func setUpDependency() {
        DependencyContainer.register(DBStoreKey.self, RealmStore())
        DependencyContainer.register(TodoRepoKey.self, TodoRepository())
        DependencyContainer.register(BehaviorRepoKey.self, BehaviorMissionRepository())
        DependencyContainer.register(TimeRepoKey.self, TimeMissionRepository())
        DependencyContainer.register(UserRepoKey.self, UserRepository())
    }
}
