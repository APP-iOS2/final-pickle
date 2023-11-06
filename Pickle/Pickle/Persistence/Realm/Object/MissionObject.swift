//
//  MissionObject.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import Foundation
import RealmSwift

protocol MissionObject {
    var title: String { get set }
    var status: TodoStatusPersisted { get set }
    var date: Date { get set } // 타임미션 생성 날짜,시간 -> 생성날짜와 지금 날짜 비교해서 초기화할 때 쓸 것
}

class TimeMissionObject: Object, MissionObject, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var status: TodoStatusPersisted
    @Persisted var date: Date
    @Persisted var wakeupTime: Date       // 기상 목표 시간
    @Persisted var changeWakeupTime: Date // 기상시간 - 변경 정보 저장
    
    convenience init(title: String,
                     status: TodoStatusPersisted,
                     date: Date,
                     wakeupTime: Date,
                     changeWakeupTime: Date) {
        self.init()
        self.id = id
        self.title = title
        self.status = status
        self.date = date
        self.wakeupTime = wakeupTime
        self.changeWakeupTime = changeWakeupTime
    }
    
    convenience init(id: String,
                     title: String,
                     status: TodoStatusPersisted,
                     date: Date,
                     wakeupTime: Date,
                     changeWakeupTime: Date) {
        
        self.init(title: title,
                  status: status,
                  date: date,
                  wakeupTime: wakeupTime,
                  changeWakeupTime: changeWakeupTime)
        
        self.id = try! ObjectId(string: id)
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension TimeMissionObject {
    static func allKeyPath() -> [PartialKeyPath<TimeMissionObject>] {
        [\.changeWakeupTime,
          \.wakeupTime,
          \.status]
    }
}
