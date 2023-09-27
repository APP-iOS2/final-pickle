//
//  PickleApp.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

@main
struct PickleApp: App {
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "__UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
           ContentView()
        }
    }
}
