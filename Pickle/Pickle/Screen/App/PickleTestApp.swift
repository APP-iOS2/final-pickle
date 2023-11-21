//
//  PickleTestApp.swift
//  PickleTests
//
//  Created by 박형환 on 11/4/23.
//

import SwiftUI
import BackgroundTasks

class TestAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}


struct PickleAppTest: App {
    @UIApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @State private var debugDelete: Bool = true
    
    // Launch Screen Delay
    init() {
        Thread.sleep(forTimeInterval: 2)
        
    }
    
    var body: some Scene {
        WindowGroup {
            if debugDelete {
                let _ = UserDefaults.standard.set(false, forKey: "__UIConstraintBasedLayoutLogUnsatisfiable")

                
                let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)

            }
            Text("TestApplication")
        }
    }
}



