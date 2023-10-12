//
//  LocalNotification.swift
//  Pickle
//
//  Created by 최소정 on 10/10/23.
//

import Foundation

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var dateComponents: DateComponents?
    var timeInterval: Double?
    var repeats: Bool
    var type: NotiType
}

enum NotiType {
    case calendar   // 특정 날짜 및 시간에 알림
    case time       // 몇 초 후 알림
}
