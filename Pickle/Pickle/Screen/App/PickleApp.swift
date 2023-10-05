//
//  PickleApp.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        PickleApp.setUpDependency()
        
        return true
    }
}

@main
struct PickleApp: App {
//    @StateObject private var todoStore = TodoStore(repository: TodoRepository.create(with: RealmStore()))
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var todoStore = TodoStore()
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "__UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
           ContentView()
                .environmentObject(todoStore)
        }
    }
}

extension PickleApp {
    
    static func setUpDependency() {
        DependencyContainer.register(type: DBStore.self, RealmStore())
        DependencyContainer.register(type: TodoRepositoryProtocol.self , TodoRepository())
    }
}
