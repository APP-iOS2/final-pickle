//
//  MySceneDelegate.swift
//  Pickle
//
//  Created by Suji Jang on 10/23/23.
//

import Foundation
import UIKit

class MySceneDelegate: UIResponder, UIWindowSceneDelegate {
    func sceneDidEnterBackground(_ scene: UIScene) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.scheduleAppRefresh()
            appDelegate.scheduleProcessingTaskIfNeeded()
        } else {
            Log.error("AppDelegate를 찾을 수 없습니다.")
        }
    }
}
