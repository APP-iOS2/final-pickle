//
//  LocalNotification.swift
//  Pickle
//
//  Created by 최소정 on 10/10/23.
//

import Foundation

enum NotiType {
    case calendar   // 특정 날짜 및 시간에 알림
    case time       // 몇 초 후 알림
}

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var dateComponents: DateComponents?
    var timeInterval: Double?
    var repeats: Bool
    var userInfo: [String: Any] = [:]
    var type: NotiType
    
    static func makeLocalNotification(_ item: Todo,
                                      before time: Int = 3) -> Self {
       
        let date = item.startTime.adding(minutes: -time)
        let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date )
        let body = "\(item.content) 시작 \(time)분전이에요"
        var info: [String: Any] = item.asDictionary
        info["status"] = item.status.rawValue
        
        let timeDifference = date.timeIntervalSince(currentDate)
        let body2 = "\(item.content) 시작할 시간이에요"

        if timeDifference > 180 {
            
            return .init(identifier: item.id,
                         title: _title,
                         body: body,
                         dateComponents: dateComp,
                         repeats: false,
                         userInfo: info,
                         type: .calendar)
        }
        return .init(identifier: item.id,
                     title: _title,
                     body: body2,
                     dateComponents: Calendar.current.dateComponents([.hour, .minute], from: Date().adding(minutes: 1)),
                     repeats: false,
                     userInfo: info,
                    type: .calendar)
    }
    static let currentDate = Date()
    static let _title: String = "현실도 피자"
}
