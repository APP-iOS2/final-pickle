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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.scheduleAppRefresh()
        appDelegate.scheduleProcessingTaskIfNeeded()
    }
}
